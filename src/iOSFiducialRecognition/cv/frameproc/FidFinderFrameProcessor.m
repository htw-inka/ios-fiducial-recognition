/*

LICENSE AGREEMENT

Copyright (c) 2013, HTW Berlin / Project MINERVA
(http://inka.htw-berlin.de/inka/projekte/minerva/)

All rights reserved.

Redistribution and use in source and binary forms, with or without
modification, are permitted provided that the following conditions
are met:

* Redistributions of source code must retain the above copyright notice,
  this list of conditions and the following disclaimer.
* Redistributions in binary form must reproduce the above copyright
  notice, this list of conditions and the following disclaimer in the
  documentation and/or other materials provided with the distribution.
* Neither the name of the HTW Berlin / INKA Research Group nor the names
  of its contributors may be used to endorse or promote products derived
  from this software without specific prior written permission.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS
IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO,
THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR
PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR
CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR
PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF
LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING
NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

*/


//
//  FidFinderFrameProcessor.m
//  IslARWallFidu
//
//  Created by Markus Konrad on 03.04.13.
//  Copyright (c) 2013 INKA Research Group. All rights reserved.
//

#import "FidFinderFrameProcessor.h"

@interface FidFinderFrameProcessor ()

@end

@implementation FidFinderFrameProcessor

@synthesize currentDetectedObjects = detectedObjs;

#pragma mark public methods

+(id)frameProcessorWithTracker:(Tracker *)t {
    return [[[FidFinderFrameProcessor alloc] initWithTracker:t] autorelease];
}

-(id)initWithTracker:(Tracker *)t {
    if ((self = [super init])) {
        tracker = t;

        firstFrame = YES;
        
        detectedObjs = [[NSMutableArray alloc] init];
        
        fiducials = new FiducialX[MAX_FIDUCIAL_COUNT];

        initialize_treeidmap(&treeidmap);
        
        frameW = frameH = 0;
        
        average_leaf_size = 4.0f;
        average_fiducial_size = 48.0f;
        
        sessionId = 0;
    }
    
    return self;
}

-(void)dealloc {
    [detectedObjs release];
    
    terminate_segmenter(&segmenter);
    terminate_treeidmap(&treeidmap);
    terminate_fidtrackerX(&fidtrackerx);
    
    delete fiducials;
    
    [super dealloc];
}

#pragma mark FrameProcessor methods


// NOTE:
// This method mainly consists of code from the reacTIVision open-source project (reactivision.sourceforge.net)
// All credits go to the creators of reacTIVision.
-(GreyscaleImg *)processImage:(GreyscaleImg *)img {    
    // initialize thresholder if neccessary
    if (firstFrame) {
        frameW = img->w;
        frameH = img->h;
        
        initialize_fidtrackerX(&fidtrackerx, &treeidmap, NULL);    // no "pixelwarp"
        initialize_segmenter(&segmenter, frameW, frameH, treeidmap.max_adjacencies );
        
        firstFrame = NO;
    }
    
	// segmentation
	step_segmenter(&segmenter, img->bytes);
	// fiducial recognition
	const int fidCount = find_fiducialsX(fiducials, MAX_FIDUCIAL_COUNT, &fidtrackerx, &segmenter, frameW, frameH);

//    NSLog(@"FidFinderFrameProcessor: Found %d fiducials.", fidCount);
    
	float total_leaf_size = 0.0f;
	float total_fiducial_size = 0.0f;
	int valid_fiducial_count = 0;
    
    // process found symbols
    for (int i = 0; i < fidCount; i++) {
        FiducialX * const fid = &fiducials[i];
        TrackableObject *existingObj = NULL;
        
		if (fid->id >=0) {
			valid_fiducial_count++;
			total_leaf_size += fid->leaf_size;
			total_fiducial_size += fid->root_size;
		}
        
        // update objects we had in the last frame
        // also check if we have an ID/position conflict
        // or correct an INVALID_FIDUCIAL_ID if we had an ID in the last frame
        for (TrackableObject *knownObj in detectedObjs) {
            const float dist = [knownObj distToX:fid->x Y:fid->y];
            
            if (fid->id == knownObj.markerId) {
                // find and match a fiducial we had last frame already ...
                if (!existingObj) {
					existingObj = knownObj;
                    
					for (int j=0; j < fidCount; j++) {
                        const FiducialX otherFid = fiducials[j];
                        //check if there is another fiducial with the same id closer
						if ((i!=j) && (otherFid.id == knownObj.markerId) && ([knownObj distToX:otherFid.x Y:otherFid.y] < dist)) {
							existingObj = NULL;
							break;
						}
					}
                    
                    for (TrackableObject *otherObj in detectedObjs) {
                        if ((otherObj != existingObj) && (otherObj.markerId == existingObj.markerId) && ([otherObj distToX:fid->x Y:fid->y] < dist)) {
                            //check if there is another fiducial with the same id closer
                            existingObj = NULL;
                            break;
                        }
                    }
                }
            } else if ((dist < average_fiducial_size / 1.2) && (abs(fid->node_count - knownObj.nodeCount) <= FUZZY_NODE_RANGE)) {
				// do we have a different ID at the same place?
				// this should correct wrong or invalid fiducial IDs
				// assuming that between two frames
				// there can't be a rapid exchange of two symbols
				// at the same place
				
				for (int j = 0; j < fidCount; j++) {
					if ((i != j) && ([knownObj distToX:fiducials[j].x Y:fiducials[j].y] < dist))
                        break;
				}
				
				if (fid->id == INVALID_FIDUCIAL_ID) {
					//two pixel threshold since missing/added leaf nodes result in a slightly different position
                    const float knownObjX = knownObj.pos.x;
                    const float knownObjY = knownObj.pos.y;
					float dx = abs(knownObjX - fiducials[i].x);
					float dy = abs(knownObjY - fiducials[i].y);
                    
					if ((dx < 2.0f) && (dy < 2.0f)) {
						fid->x = (short int)knownObjX;
						fid->y = (short int)knownObjY;
					}
					
					fid->angle = knownObj.angle;
					fid->id = knownObj.markerId;
                    [knownObj setState:FIDUCIAL_INVALID];
				} else /*if (fiducials[i].id!=fiducial->fiducial_id)*/ {
                    if (![knownObj checkIdConflictUsingSessId:sessionId andMarkerId:fid->id]) {
                        fid->id = knownObj.markerId;
					} else {
						sessionId++;
					}
				}
				
                existingObj = knownObj;
				break;
			}
		}   // for (TrackableObject *knownObj in detectedObjs)
        
		if  (existingObj) {
			// just update the fiducial from last frame ...
            [existingObj updateWithX:fid->x Y:fid->y angle:fid->angle rootSize:fid->root_size leafSize:fid->leaf_size];
            [tracker.delegate tracker:tracker tracedObject:existingObj];
		} else if  (fid->id != INVALID_FIDUCIAL_ID) {
			// add the newly found object
			sessionId++;
            
            TrackableObject *newObj = [TrackableObject trackableObjectWithMarkerId:fid->id sessId:sessionId rootColor:fid->root_colour nodeCount:fid->node_count];
            [newObj updateWithX:fid->x Y:fid->y angle:fid->angle rootSize:fid->root_size leafSize:fid->leaf_size];
            
            [detectedObjs addObject:newObj];

			[tracker.delegate tracker:tracker foundObject:newObj];
		}
    }
    
    // check if we can remove any objects
    NSMutableArray *newDetectedObjs = [[NSMutableArray alloc] initWithCapacity:detectedObjs.count];
    for (TrackableObject *obj in detectedObjs) {
        if ([obj isAlive]) {
            [newDetectedObjs addObject:obj];
            [obj setUpdated:NO];
        } else {
            [tracker.delegate tracker:tracker lostObject:obj];
        }
    }
    
    [detectedObjs release];
    detectedObjs = newDetectedObjs;
    
    
    // output image = input image!
    return img;
}

#pragma mark private methods



@end
