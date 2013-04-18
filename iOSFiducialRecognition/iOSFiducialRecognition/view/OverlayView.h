//
//  OverlayView.h
//  IslARWallApp
//
//  Created by Markus Konrad on 14.03.13.
//  Copyright (c) 2013 INKA Research Group. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "Tracker.h"
#import "OverlayRegion.h"

@interface OverlayView : UIView<TrackerDelegate> {
    CGPoint objPointScaling;
    CGSize frameSize;
    Tracker *tracker;   // reference to singleton
    NSMutableDictionary *detectedObjects;   // dictionary with NSNumber (marker id) -> TrackableObject mapping
}

@property (nonatomic, retain) AVCaptureVideoPreviewLayer *previewLayerRef;

@end
