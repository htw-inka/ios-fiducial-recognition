//
//  ThresholderFrameProcessor.h
//  IslARWallFidu
//
//  Created by Markus Konrad on 03.04.13.
//  Copyright (c) 2013 INKA Research Group. All rights reserved.
//

#import <Foundation/Foundation.h>

#include "tiled_bernsen_threshold.h"

#import "cv_types.h"
#import "FrameProcessor.h"
#import "Tracker.h"

@class Tracker;

@interface ThresholderFrameProcessor : NSObject<FrameProcessor> {
    Tracker *tracker;
    TiledBernsenThresholder *thresholder;
    BOOL firstFrame;
}

+(id)frameProcessorWithTracker:(Tracker *)tracker;
-(id)initWithTracker:(Tracker *)tracker;

@property (nonatomic, assign) short tileSize;
@property (nonatomic, assign) short gradient;

@end
