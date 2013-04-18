//
//  CamCapture.m
//  IslARWallApp
//
//  Created by Markus Konrad on 13.03.13.
//  Copyright (c) 2013 INKA Research Group. All rights reserved.
//

#import "CamCapture.h"

#import "Tools.h"

@interface CamCapture ()

/**
 * Setup the capture session
 */
- (void) setupSession;

#if (TARGET_IPHONE_SIMULATOR == 1)
/**
 * Dummy timer callback
 * @param timer Timer that elapsed
 */
- (void) timerCallback:(NSTimer*)timer;
#endif

/**
 * Callback to tell the main thread that a frame was grabbed
 * @param image Grabbed image frame (GreyscaleImg* in NSValue)
 */
- (void) frameGrabbingFinishedCallback:(NSValue *)imagePointerValue;

@end

@implementation CamCapture

@synthesize delegate;
@synthesize captureRate;
@synthesize captureSize;
@synthesize cameraType;
#if (TARGET_IPHONE_SIMULATOR == 0)
@synthesize videoPreviewLayer;
#else
@synthesize simulatorDummyImage;
#endif

#pragma mark public methods

-(id)init {
    if ((self = [super init])) {
        // default values
#ifdef CAMERA_CAPTURE_RATE
        captureRate = CAMERA_CAPTURE_RATE;
#else
        captureRate = 0;    // allways capture!
#endif
        cameraType = AVCaptureDevicePositionBack;
        
        // Setup the capture session
        [self setupSession];
    }
    
    return self;
}

-(void)dealloc {
    [session release];
#if (TARGET_IPHONE_SIMULATOR == 0)
    [videoPreviewLayer release];
#else
    [simulatorDummyImage release];
#endif
    [grabber release];
    [stillImageView release];
    [stillImageTimer release];
    if (curInputImage) free(curInputImage);
    
    [super dealloc];
}

- (void) start {
#if (TARGET_IPHONE_SIMULATOR == 0)
	// Check if the session isn't running
	if ([session isRunning]) {
		return;
	}
    
	[session startRunning];
#else
    if (stillImageTimer != nil) {
        [stillImageTimer invalidate];
        [stillImageTimer release];
    }
    
    stillImageTimer = [[NSTimer scheduledTimerWithTimeInterval:captureRate
                                                        target:self
                                                      selector:@selector(timerCallback:)
                                                      userInfo:nil
                                                       repeats:YES] retain];
#endif
}

- (void) stop {
#if (TARGET_IPHONE_SIMULATOR == 0)
	// Check if the session is running
	if (![session isRunning]) {
		return;
	}
	
	[session stopRunning];
#else
    [stillImageTimer invalidate];
    [stillImageTimer release];
    stillImageTimer = nil;
#endif
}

- (void) setRunning:(BOOL)state {
	// Easy access to start and stop messages
	if (state == YES) {
		[self start];
	} else {
		[self stop];
	}
}

- (BOOL) isRunning {
	return [session isRunning];
}

#pragma mark AVCaptureVideoDataOutputSampleBufferDelegate messages

- (void)captureOutput:(AVCaptureOutput *)captureOutput
didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer
       fromConnection:(AVCaptureConnection *)connection {
#ifdef CAMERA_CAPTURE_RATE
	// Check if we need to capture
    if (CACurrentMediaTime() < lastCapture + captureRate) {
        return;
    }
#endif
    
    // Since we are no longer in the main thread the main autorelease pool isn't addressed by our locally created objects
    // So we have the create an autorelease pool ourselves
	@autoreleasepool {
#ifdef DEBUG_ENABLE_STATS
        [Tools timerStart];
#endif
        
        // Extract the image from the video sample buffer
        CVImageBufferRef imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer);
        // Lock the image buffer
        CVPixelBufferLockBaseAddress(imageBuffer,0);
        
        // Get information about the image
        uint8_t * const baseAddress = (uint8_t *)CVPixelBufferGetBaseAddress(imageBuffer);
        const size_t width = CVPixelBufferGetWidth(imageBuffer);
        const size_t height = CVPixelBufferGetHeight(imageBuffer);
        
        // Build an image from the data
        GreyscaleImg *newImage = [Tools convertRawRGBADataToGreyscaleImg:baseAddress withWidth:width height:height];
                
#ifdef DEBUG_ENABLE_STATS
        NSLog(@"CamCapture: Cam Input processing took %f sec.", [Tools timerStop]);
#endif
        
        captureSize = CGSizeMake(width, height);
        
//#if PORTRAIT == 1
//        captureSize = CGSizeMake([result size].height, [result size].width);
//#else
//        captureSize = [result size];
//#endif
        
        // We unlock the image buffer
        CVPixelBufferUnlockBaseAddress(imageBuffer,0);
        
        // Tell the delegate the new image
        [self performSelectorOnMainThread:@selector(frameGrabbingFinishedCallback:) withObject:[NSValue valueWithPointer:newImage] waitUntilDone:NO];
        
        // Do update
        curInputImage = newImage;
        lastCapture = CACurrentMediaTime();
    }
}

#pragma mark private messages

- (void) frameGrabbingFinishedCallback:(NSValue *)imagePointerValue {
    [delegate camCapture:self grabbedFrame:(GreyscaleImg *)[imagePointerValue pointerValue]];
    
#if (TARGET_IPHONE_SIMULATOR == 1)
    [self stop];    // on the simulator, do the whole thing only once
#endif
}

- (void) timerCallback:(NSTimer*)timer {
    [self performSelectorOnMainThread:@selector(frameGrabbingFinishedCallback:) withObject:[NSValue valueWithPointer:curInputImage] waitUntilDone:NO];
}

- (void)setupSession {
    NSLog(@"CamCapture: Setting up session...");
    
#if (TARGET_IPHONE_SIMULATOR == 1)
    NSLog(@"CamCapture: Running in Simulator, using still image %@", DEBUG_SIMULATOR_TESTIMG_SCENE);
    simulatorDummyImage = [[UIImage imageNamed:DEBUG_SIMULATOR_TESTIMG_SCENE] retain];
    curInputImage = [Tools convertUIImageToGreyscaleImg:simulatorDummyImage scaleToSize:simulatorDummyImage.size];
    NSAssert(curInputImage != nil, @"CamCapture: DEBUG_SIMULATOR_TESTIMG_SCENE picture could not be read.");
#else
    // Create our capture session
    session = [[AVCaptureSession alloc] init];
    [session setSessionPreset:CAMERA_VIEW_QUALITY];
    
    // Find the right camera
    NSArray* videoDevices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
    AVCaptureDevice* camera = nil;
    
    for (AVCaptureDevice* device in videoDevices) {
        if (device.position == cameraType) {
            camera = device;
            break;
        }
    }
    
    // We need a camera device
    NSAssert(camera != nil, @"No back camera available");
    
    NSLog(@"CamCapture: Using camera %@", camera.modelID);
    
    // If we setup the session, we also are responsible to setup the
    // video device (default camera device) for image capture
    NSError* error = nil;
    [camera lockForConfiguration:&error];
    [camera setWhiteBalanceMode:AVCaptureWhiteBalanceModeContinuousAutoWhiteBalance];
    [camera unlockForConfiguration];
    
    // Create a AVCaptureInput with the camera device
    AVCaptureInput* cameraInput = [[AVCaptureDeviceInput alloc] initWithDevice:camera error:&error];
    [session addInput:cameraInput];
    [cameraInput release];
    
    // Create the video preview layer
    videoPreviewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:session];
    [videoPreviewLayer setBackgroundColor:[UIColor blackColor].CGColor];
    [videoPreviewLayer setVideoGravity:CAMERA_VIEW_RESIZE_MODE];
    [videoPreviewLayer setOrientation:VIDEOCAPTUREORIENTATION];
    
    // Add the single frame grabber
    grabber = [[AVCaptureVideoDataOutput alloc] init];
    [grabber setAlwaysDiscardsLateVideoFrames:YES];
    //    [grabber setMinFrameDuration:CMTimeMake(1, 60)];
    
    // Create a serial queue to handle the processing of our frames
	dispatch_queue_t queue;
	queue = dispatch_queue_create("cameraQueue", NULL);
	[grabber setSampleBufferDelegate:self queue:queue];
	dispatch_release(queue);
    
	// Set the video output to store frame in BGRA (It is supposed to be faster)
	NSString* key = (NSString*)kCVPixelBufferPixelFormatTypeKey;
	NSNumber* value = [NSNumber numberWithUnsignedInt:kCVPixelFormatType_32BGRA];
	NSDictionary* videoSettings = [NSDictionary dictionaryWithObject:value forKey:key];
	[grabber setVideoSettings:videoSettings];
    
    [session addOutput:grabber];
#endif
}


@end
