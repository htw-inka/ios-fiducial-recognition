//
//  Tools.h
//  IslARWallApp
//
//  Created by Markus Konrad on 14.03.13.
//  Copyright (c) 2013 INKA Research Group. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "cv_types.h"

@interface Tools : NSObject

// Convert UIImage to greyscale image
// uiImg will not be released!
+(GreyscaleImg *)convertUIImageToGreyscaleImg:(UIImage *)uiImg scaleToSize:(CGSize)scaledSize;

// Convert greyscale image to autorelease UIImage
// gsImg will not be freed!
+(UIImage *)convertGreyscaleImgToUIImage:(GreyscaleImg *)gsImg;

+(GreyscaleImg *)convertRawRGBADataToGreyscaleImg:(UInt8 *)inData withWidth:(int)inW height:(int)inH;

// errornous!
//+(GreyscaleImg *)convertRawRGBAData:(UInt8 *)inData withWidth:(int)inW height:(int)inH toGreyScaleImgOfWidth:(int)outW height:(int)outH;

// Todo:
//+(UInt8 *)gaussianSamplingOnRGBAData:(UInt8 *)inData withWidth:(int)inW height:(int)inH toGreyScaleImgOfWidth:(int)outW height:(int)outH;

// Timer functions for benchmarking
+(void)timerStart;
+(NSTimeInterval)timerStop;

@end
