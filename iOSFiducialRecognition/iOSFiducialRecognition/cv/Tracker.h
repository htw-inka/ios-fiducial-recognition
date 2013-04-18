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
