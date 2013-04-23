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
//  Tracker.m
//  IslARWallApp
//
//  Created by Markus Konrad on 13.03.13.
//  Copyright (c) 2013 INKA Research Group. All rights reserved.
//

#import "Tracker.h"

#import "Tools.h"

@interface Tracker ()

@end

@implementation Tracker

@synthesize lastTrackingLoopTime;
@synthesize running;
@synthesize delegate;
//@synthesize detectedObjs = _detectedObjs;

#ifdef DEBUG
@synthesize debugOverlayView;
#endif

#pragma mark public methods

-(id)init {
    if ((self = [super init])) {
        // set default values
        running = NO;
        grabbedInitialFrame = NO;
        lastTrackingLoopTime = 0.0;

        // set up available trackable objects
//        _detectedObjs = [[NSMutableDictionary alloc] init];
        
        FidFinderFrameProcessor *fidFinder = [FidFinderFrameProcessor frameProcessorWithTracker:self];
        _detectedObjects = fidFinder.currentDetectedObjects;
        // create list of frame processors
        frameProcessors = [[NSArray alloc] initWithObjects:
//                           [InitialFrameProcessor frameProcessorWithTracker:self],
//                           [EqualizerFrameProcessor frameProcessorWithTracker:self],
                           [ThresholderFrameProcessor frameProcessorWithTracker:self],
                           fidFinder,
                           nil];
    }

    return self;
}

-(void)dealloc {
//    [_detectedObjs release];
    
    [super dealloc];
}

- (void) setRunning:(BOOL)state {
	// Easy access to start and stop messages
	if (state == YES) {
		[self start];
	} else {
		[self stop];
	}
}

-(void)start {
    running = YES;
    grabbedInitialFrame = NO;
}

-(void)stop {
    running = NO;
}

-(NSArray *)currentDetectedObjects {
    return _detectedObjects;
}

#pragma mark CamCaptureDelegate methods

-(void)camCapture:(CamCapture *)camCap grabbedFrame:(GreyscaleImg *)frame {
    if (!running) return;
    
    const CFTimeInterval processingStartSec = CACurrentMediaTime();
    
    // go through the list of frame processors
    GreyscaleImg *srcFrame, *destFrame;
    
//    // for testing:
//    UIImage *convertedFrame = [Tools convertGreyscaleImgToUIImage:srcFrame];
//    [debugOverlayView displayImage:convertedFrame inRect:CGRectMake(0, 0, convertedFrame.size.width, convertedFrame.size.height)];
//    running = NO;
    
    srcFrame = frame;
    for (id<FrameProcessor> proc in frameProcessors) {
#ifdef DEBUG_ENABLE_STATS
        [Tools timerStart];
#endif

        // inform the delegate on the first grabbed frame
        if (!grabbedInitialFrame) {
            [delegate tracker:self grabbedInitialFrameOfSize:CGSizeMake(srcFrame->w, srcFrame->h)];
            grabbedInitialFrame = YES;
        }
        
        destFrame = [proc processImage:srcFrame];
        
        if (destFrame != srcFrame) {
            delete srcFrame;
            srcFrame = destFrame;
        }
        
#ifdef DEBUG_ENABLE_STATS
        NSLog(@"Tracker: %@ \t\t\t took %f sec.", [proc class], [Tools timerStop]);
#endif
    }
    
//    // for testing:
//    UIImage *convertedFrame = [Tools convertGreyscaleImgToUIImage:srcFrame];
//    [debugOverlayView displayImage:convertedFrame inRect:CGRectMake(0, 0, convertedFrame.size.width, convertedFrame.size.height)];
//    running = NO;
    
    delete srcFrame;
    
    // update loop time
    lastTrackingLoopTime = CACurrentMediaTime() - processingStartSec;
}

#pragma mark private methods


#pragma mark singleton stuff

static Tracker *sharedObject;

+ (Tracker*)shared {
    if (sharedObject == nil) {
        sharedObject = [[super allocWithZone:NULL] init];
    }
    return sharedObject;
}

+ (void)destroy {
    [sharedObject dealloc];
}

+ (id)allocWithZone:(NSZone *)zone {
    return [[self shared] retain];
}

- (id)copyWithZone:(NSZone *)zone {
    return self;
}

- (id)retain {
    return self;
}

- (NSUInteger)retainCount {
    return NSUIntegerMax;  //denotes an object that cannot be released
}

- (oneway void)release {
    //do nothing
}

- (id)autorelease {
    return self;
}


@end
