//
//  ViewController.h
//  iOSFiducialRecognition
//
//  Created by Markus Konrad on 18.04.13.
//  Copyright (c) 2013 INKA Research Group. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "CamCapture.h"
#import "CameraView.h"
#import "OverlayView.h"
#import "Tracker.h"

#ifdef DEBUG
#import "DebugOverlayView.h"
#endif

@interface ViewController : UIViewController {
    CamCapture *camCapture;
    Tracker *tracker;
    OverlayView *overlayView;
    
#ifdef DEBUG
    DebugOverlayView *debugOverlayView;
#endif
}

@property (nonatomic, assign) IBOutlet CameraView *cameraView;

@end

