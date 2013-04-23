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
//  CamCapture.h
//  IslARWallApp
//
//  Created by Markus Konrad on 13.03.13.
//  Copyright (c) 2013 INKA Research Group. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

#import "cv_types.h"

#if (TARGET_IPHONE_SIMULATOR == 1)

// Simulator doesn't have any camera input
@class AVCaptureSession;
@class AVCaptureVideoPreviewLayer;
@class AVCaptureStillImageOutput;

@protocol AVCaptureVideoDataOutputSampleBufferDelegate;

#endif

@class CamCapture;

/**
 * Protocol for CamCapture delegate class, which can receive camera frames
 */
@protocol CamCaptureDelegate <NSObject>

/**
 * The camera capture class grabbed a frame from the input stream
 * @param camCap CamCapture that grabbed the frame
 * @param frame Frame that was grabbed
 */
- (void) camCapture:(CamCapture*)camCap grabbedFrame:(GreyscaleImg *)frame;

@end

/**
 * Class that will capture a camera image.
 */
@interface CamCapture : NSObject<AVCaptureVideoDataOutputSampleBufferDelegate> {
    // Current capturing session
	AVCaptureSession *session;
    
    // Image grabber
    AVCaptureVideoDataOutput *grabber;
    
    // Saves the timestamp of the last frame capture
    NSTimeInterval lastCapture;
    
    // ImageView for processed image
    UIImageView *stillImageView;
    NSTimer *stillImageTimer;
    
    // image for input image
    GreyscaleImg *curInputImage;
}

// delegate that will receive the grabbed frame
@property (nonatomic, assign) id<CamCaptureDelegate> delegate;
@property (nonatomic, getter=isRunning) BOOL running;
@property (nonatomic, assign) CGFloat captureRate;
@property (nonatomic, readonly) CGSize captureSize;
#if (TARGET_IPHONE_SIMULATOR == 0)
@property (nonatomic, readonly) AVCaptureVideoPreviewLayer *videoPreviewLayer;  // The video preview layer
#else
@property (nonatomic, readonly) UIImage *simulatorDummyImage;   // dummy image for simulator
#endif
@property (nonatomic, assign) AVCaptureDevicePosition cameraType; // Camera type (front / back)

/**
 * Start the capture session
 */
-(void)start;

/**
 * Stop the capture session
 */
-(void)stop;

@end
