//
//  EqualizerFrameProcessor.m
//  IslARWallFidu
//
//  Created by Markus Konrad on 30.03.13.
//  Copyright (c) 2013 INKA Research Group. All rights reserved.
//

#include <algorithm>

#import "EqualizerFrameProcessor.h"

#import "Tools.h"

@implementation EqualizerFrameProcessor

#pragma mark public methods

+(id)frameProcessorWithTracker:(Tracker *)t {
    return [[[EqualizerFrameProcessor alloc] initWithTracker:t] autorelease];
}

-(id)initWithTracker:(Tracker *)t {
    if ((self = [super init])) {
        tracker = t;
    }
    
    return self;
}

#pragma mark FrameProcessor methods

-(GreyscaleImg *)processImage:(GreyscaleImg *)img {
    // create histogram and get min and max grey levels
    float hist[256];
    std::fill(hist, hist+256, 0.0f);
    
    const unsigned int dataLen = img->w * img->h;
    float maxHistVal = 0.0f;
    UInt8 minVal = 255;
    UInt8 maxVal = 0;
    UInt8 pxlVal;
    for (int i = 0; i < dataLen; i++) {
        pxlVal = img->bytes[i];
        hist[pxlVal] += 1.0f;
        minVal = MIN(minVal, pxlVal);
        maxVal = MAX(maxVal, pxlVal);
        maxHistVal = MAX(maxHistVal, hist[pxlVal]);
    }
    
//    NSLog(@"EqualizerFrameProcessor: Min/max px value: %d / %d", minVal, maxVal);
//    NSLog(@"EqualizerFrameProcessor: Max hist value: %f", maxHistVal);
    
//    for (int i = 0; i < 256; i++) {
////        hist[i] /= maxHistVal;
//        NSLog(@"EqualizerFrameProcessor: hist[%d]=%f", i, hist[i]);
//    }
    
    // create the cumulative distribution function (cdf)
    const unsigned int cdfSize = maxVal - minVal + 1;
    double cdf[cdfSize];
    cdf[0] = hist[minVal];
    for (int i = 1; i < cdfSize; i++) {
        cdf[i] = cdf[i-1] + hist[minVal + i];
    }
    
    // equalize the CDF
    const double cdfMin = cdf[0];
    const double N = 255.0 / (double)(dataLen - 1);
    for (int i = 0; i < cdfSize; i++) {
        cdf[i] = round((cdf[i] - cdfMin) * N);
    }
    
    // equalize the image using the CDF
    GreyscaleImg *imgOut = new GreyscaleImg;
    imgOut->w = img->w;
    imgOut->h = img->h;
    imgOut->bytes = new UInt8[dataLen];
    for (int i = 0; i < dataLen; i++) {
        imgOut->bytes[i] = (UInt8)(cdf[img->bytes[i] - minVal]);
    }
    
    return imgOut;
}

@end
