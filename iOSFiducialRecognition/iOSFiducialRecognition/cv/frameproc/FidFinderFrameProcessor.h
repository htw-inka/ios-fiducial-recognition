//
//  FidFinderFrameProcessor.h
//  IslARWallFidu
//
//  Created by Markus Konrad on 03.04.13.
//  Copyright (c) 2013 INKA Research Group. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "cv_types.h"
#import "FrameProcessor.h"
#import "Tracker.h"

#include "segment.h"
#include "fidtrackX.h"

#define MAX_FIDUCIAL_COUNT 128

@class Tracker;

// NOTE:
// This class consists partly of code from the reacTIVision open-source project (reactivision.sourceforge.net)
// All credits for these parts go to the creators of reacTIVision.
@interface FidFinderFrameProcessor : NSObject<FrameProcessor> {
    Tracker *tracker;
    
    unsigned int frameW;
    unsigned int frameH;
    BOOL firstFrame;
    int sessionId;
    
    // Currently detected trackable objects
//    NSMutableDictionary *detectedObjs;   // NSMutableDictionary with mapping NSNumber (markerId) -> TrackableObject
    NSMutableArray *detectedObjs;   // NSMutableDictionary with mapping NSNumber (markerId) -> TrackableObject
    
	Segmenter segmenter;
    
	FiducialX *fiducials;
//	RegionX regions[MAX_FIDUCIAL_COUNT * 4];
	TreeIdMap treeidmap;
	FidtrackerX fidtrackerx;
    
    float average_leaf_size;
    float average_fiducial_size;
}

@property (nonatomic, readonly) NSArray *currentDetectedObjects;

+(id)frameProcessorWithTracker:(Tracker *)tracker;
-(id)initWithTracker:(Tracker *)tracker;

@end
