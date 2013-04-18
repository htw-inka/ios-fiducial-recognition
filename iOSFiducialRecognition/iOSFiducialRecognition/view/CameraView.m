//
//  CameraView.m
//  IslARWallApp
//
//  Created by Markus Konrad on 13.03.13.
//  Copyright (c) 2013 INKA Research Group. All rights reserved.
//

#import "CameraView.h"

@implementation CameraView

#pragma mark public methods

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setBackgroundColor:[UIColor blackColor]];
    }
    return self;
}

-(void)dealloc {
    [videoPreviewLayer release];
    
    [super dealloc];
}

#if (TARGET_IPHONE_SIMULATOR == 0)
-(void)setVideoPreviewLayer:(AVCaptureVideoPreviewLayer *)vidLayer {
    [videoPreviewLayer removeFromSuperlayer];
    [videoPreviewLayer release];
    
    videoPreviewLayer = [vidLayer retain];
    [videoPreviewLayer setFrame:[self bounds]];
    [self.layer addSublayer:videoPreviewLayer];
}
#else
-(void)setSimulatorDummyImage:(UIImage *)dummyImage {
    UIImageView *imgView = [[[UIImageView alloc] initWithImage:dummyImage] autorelease];
    [imgView setFrame:self.frame];
    [self addSubview:imgView];
}
#endif

@end
