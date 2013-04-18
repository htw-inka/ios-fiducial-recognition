//
//  CameraView.h
//  IslARWallApp
//
//  Created by Markus Konrad on 13.03.13.
//
//  Copyright (c) 2013 INKA Research Group. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <AVFoundation/AVFoundation.h>

/**
 * View that displays the camera input
 */
@interface CameraView : UIView {
    AVCaptureVideoPreviewLayer *videoPreviewLayer;
}

#if (TARGET_IPHONE_SIMULATOR == 0)
-(void)setVideoPreviewLayer:(AVCaptureVideoPreviewLayer *)vidLayer;
#else
-(void)setSimulatorDummyImage:(UIImage *)dummyImage;
#endif

@end

