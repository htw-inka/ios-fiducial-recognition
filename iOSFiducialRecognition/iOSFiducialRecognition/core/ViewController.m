//
//  ViewController.m
//  iOSFiducialRecognition
//
//  Created by Markus Konrad on 18.04.13.
//  Copyright (c) 2013 INKA Research Group. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

@synthesize cameraView;

#pragma mark public methods

-(void)dealloc {
#ifdef DEBUG
    [debugOverlayView removeFromSuperview];
    [debugOverlayView release];
#endif
    
    [overlayView removeFromSuperview];
    [overlayView release];
    
    [camCapture release];
    
    [Tracker destroy];
    
    [super dealloc];
}

#pragma mark UIViewController methods

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
    
    // init Tracker, but set him up later
    tracker = [Tracker shared];
    
    // set up camera capture
    camCapture = [[CamCapture alloc] init];
#if (TARGET_IPHONE_SIMULATOR == 0)
    [cameraView setVideoPreviewLayer:camCapture.videoPreviewLayer];
#else
    [cameraView setSimulatorDummyImage:camCapture.simulatorDummyImage];
#endif
    [camCapture start];
    
    // set up overlay view
    overlayView = [[OverlayView alloc] initWithFrame:cameraView.frame];
#if (TARGET_IPHONE_SIMULATOR == 0)
    [overlayView setPreviewLayerRef:camCapture.videoPreviewLayer];
#endif
    [cameraView addSubview:overlayView];
    
#ifdef DEBUG
    debugOverlayView = [[DebugOverlayView alloc] initWithFrame:cameraView.frame];
    [overlayView addSubview:debugOverlayView];
#endif
    
    // set up tracker
    [camCapture setDelegate:tracker];   // tracker gets informed about new camera images by CamCapture
    [tracker setDelegate:overlayView];  // and the overlay gets informed about found objects from the Tracker
    
#ifdef DEBUG
    [tracker setDebugOverlayView:debugOverlayView];
#endif
    
    // start tracking
    [tracker start];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
