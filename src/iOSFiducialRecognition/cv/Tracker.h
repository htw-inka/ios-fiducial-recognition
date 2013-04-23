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
//  Tracker.h
//  IslARWallApp
//
//  Created by Markus Konrad on 13.03.13.
//  Copyright (c) 2013 INKA Research Group. All rights reserved.
//

#import <Foundation/Foundation.h>

#include <vector>

#import "Singleton.h"
#import "FrameProcessor.h"
#import "CamCapture.h"
#import "TrackableObject.h"
#import "DebugOverlayView.h"

#import "EqualizerFrameProcessor.h"
#import "ThresholderFrameProcessor.h"
#import "FidFinderFrameProcessor.h"

using namespace std;

@class Tracker;

// TrackerDelegate protocol informs a delegate of the tracker about found/moved/lost objects.
@protocol TrackerDelegate<NSObject>

-(void)tracker:(Tracker *)tracker grabbedInitialFrameOfSize:(CGSize)frameSize;
-(void)tracker:(Tracker *)tracker foundObject:(TrackableObject *)obj;
-(void)tracker:(Tracker *)tracker tracedObject:(TrackableObject *)obj;
-(void)tracker:(Tracker *)tracker lostObject:(TrackableObject *)obj;

@end

// Tracker receives input images from the camera and tries to detect query images in it.
@interface Tracker : NSObject<CamCaptureDelegate, Singleton> {
    // is set to YES after the initial frame was grabbed an the delegate was informed
    BOOL grabbedInitialFrame;
    
    // List of frame processors
    NSArray *frameProcessors;   // NSArray with objects of type id<FrameProcessor>
    
    // pointer to detected objects
    NSArray *_detectedObjects;
}

@property (nonatomic, readonly) CFTimeInterval lastTrackingLoopTime;
@property (nonatomic, getter=isRunning) BOOL running;
@property (nonatomic, assign) id<TrackerDelegate> delegate;
//@property (nonatomic, readonly) NSDictionary *detectedObjs;
#ifdef DEBUG
@property (nonatomic, assign) DebugOverlayView *debugOverlayView;
#endif

// start the tracking process
-(void)start;

// stop the tracking process
-(void)stop;

// pointer to currently detected objects
-(NSArray *)currentDetectedObjects;

@end
