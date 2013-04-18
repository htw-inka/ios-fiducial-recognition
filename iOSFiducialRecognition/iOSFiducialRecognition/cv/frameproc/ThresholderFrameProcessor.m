//
//  ThresholderFrameProcessor.m
//  IslARWallFidu
//
//  Created by Markus Konrad on 03.04.13.
//  Copyright (c) 2013 INKA Research Group. All rights reserved.
//

#import "ThresholderFrameProcessor.h"

@implementation ThresholderFrameProcessor

@synthesize tileSize, gradient;

#pragma mark public methods

+(id)frameProcessorWithTracker:(Tracker *)t {
    return [[[ThresholderFrameProcessor alloc] initWithTracker:t] autorelease];
}

-(id)initWithTracker:(Tracker *)t {
    if ((self = [super init])) {
        tracker = t;
        thresholder = new TiledBernsenThresholder;
        firstFrame = YES;
        tileSize = 12;
        gradient = 32;
    }
    
    return self;
}

-(void)dealloc {
    terminate_tiled_bernsen_thresholder(thresholder);
    delete thresholder;
    
    [super dealloc];
}

#pragma mark FrameProcessor methods

-(GreyscaleImg *)processImage:(GreyscaleImg *)img {
    // create output image
    GreyscaleImg *imgOut = new GreyscaleImg;
    imgOut->w = img->w;
    imgOut->h = img->h;
    imgOut->bytes = new UInt8[img->w * img->h];
    
    // initialize thresholder if neccessary
    if (firstFrame) {
        initialize_tiled_bernsen_thresholder(thresholder, img->w, img->h, tileSize);
        firstFrame = NO;
    }
    
    // do the thresholding
    tiled_bernsen_threshold(thresholder, imgOut->bytes, img->bytes, 1, img->w, img->h, tileSize, gradient);
    
    return imgOut;
}


@end
