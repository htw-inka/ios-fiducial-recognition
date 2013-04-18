//
//  EqualizerFrameProcessor.h
//  IslARWallFidu
//
//  Created by Markus Konrad on 30.03.13.
//  Copyright (c) 2013 INKA Research Group. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "cv_types.h"
#import "FrameProcessor.h"
#import "Tracker.h"

@class Tracker;

@interface EqualizerFrameProcessor : NSObject<FrameProcessor> {
    Tracker *tracker;
}

+(id)frameProcessorWithTracker:(Tracker *)tracker;
-(id)initWithTracker:(Tracker *)tracker;

@end
