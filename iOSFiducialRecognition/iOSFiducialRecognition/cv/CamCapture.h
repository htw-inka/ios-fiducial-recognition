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
