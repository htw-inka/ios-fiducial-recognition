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
