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
//  TrackableObject.m
//  IslARWallApp
//
//  Created by Markus Konrad on 22.03.13.
//  Copyright (c) 2013 INKA Research Group. All rights reserved.
//

#import "TrackableObject.h"

#define FUZZY_DIST(dX,dY) (dX)*(dX)+(dY)*(dY)
#define NORMAL_DIST(dX,dY) sqrt(FUZZY_DIST(dX,dY))
#define DIST_FUNC(dX,dY) FUZZY_DIST(dX,dY)

#define MAX_LOST_FRAMES 2

@implementation TrackableObject

@synthesize markerId;
@synthesize sessId;
@synthesize nodeCount;
@synthesize pos;
@synthesize angle;
@synthesize state;
@synthesize lastDetection;
@synthesize rootSize;
@synthesize leafSize;
@synthesize rootColor;
@synthesize updated;
@synthesize overlayRegion;

#pragma mark init/dealloc

+(TrackableObject *)trackableObjectWithMarkerId:(int)mId sessId:(int)sId rootColor:(int)rootClr nodeCount:(int)nCount {
    return [[[TrackableObject alloc] initWithMarkerId:mId sessId:sId rootColor:rootClr nodeCount:nCount] autorelease];
}

-(id)initWithMarkerId:(int)mId sessId:(int)sId rootColor:(int)rootClr nodeCount:(int)nCount {
    if ((self = [super init])) {
        markerId = mId;
        sessId = sId;
        rootColor = rootClr;
        nodeCount = nCount;
        
        lastDetection = 0;
        id_buffer_index = 0;
        lost_frames = 0;
        updated = YES;
//        prevPos = CGPointZero;
//        prevAngle = 0.0f;
    }
    
    return self;
}

-(void)dealloc {
    [overlayRegion release];
    
    [super dealloc];
}

-(float)distToX:(float)x Y:(float)y {
    return DIST_FUNC(pos.x - x, pos.y - y);
}

#pragma mark public methods

-(void)updateWithX:(float)x Y:(float)y angle:(float)a rootSize:(float)rSize leafSize:(float)lSize {
    // update properties
    lastDetection = CACurrentMediaTime();
    pos.x = x;
    pos.y = y;
    angle = a;
    rootSize = rSize;
    leafSize = lSize;
    
    // reset state
    state = FIDUCIAL_FOUND;
    lost_frames = 0;
    updated = YES;
}

// NOTE:
// This method mainly consists of code from the reacTIVision open-source project (reactivision.sourceforge.net)
// All credits go to the creators of reacTIVision.
-(BOOL)checkIdConflictUsingSessId:(int)s_id andMarkerId:(int)f_id {
	id_buffer[id_buffer_index] = f_id;
    
	int error=0;
	for (int i=0;i<6;i++) {
		int index = i+id_buffer_index;
		if(index==6) index-=6;
		if (id_buffer[index]==f_id) error++;
	}
    
	id_buffer_index++;
	if (id_buffer_index==6) id_buffer_index=0;
    
	if (error > 4) {
		//printf("--> corrected wrong object ID from %d to %d\n",fiducial_id,f_id);
		markerId = f_id;
		sessId = s_id + 1;
		state = FIDUCIAL_WRONG;
		return YES;
	}
    
	return NO;

}

-(BOOL)isAlive {
    if (updated) return YES;
    
	// we remove an object if it hasn't appeared in the last n frames
    if (lost_frames > MAX_LOST_FRAMES) {
        return NO;
    } else {
        lost_frames++;
        state = FIDUCIAL_LOST;
    }
    
	return YES;
}

#pragma mark NSObject overrides

-(NSString *)description {
    return [NSString stringWithFormat:@"TrackableObject #%d (SID %d) @ pos (%f,%f)", markerId, sessId, pos.x, pos.y];
}

@end
