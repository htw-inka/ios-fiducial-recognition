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
//  Tools.m
//  IslARWallApp
//
//  Created by Markus Konrad on 14.03.13.
//  Copyright (c) 2013 INKA Research Group. All rights reserved.
//

#import "Tools.h"

//#define GREY_VALUE_FROM_RGB_VALUE(v) ((((v) >> 24) + ((v) >> 16) + ((v) >> 8)) / 3)
#define GREY_VALUE_FROM_RGB_VALUE(v) (((*v) + (*(v + 1)) + (*(v + 2))) / 3)

// used for timer functions
static NSTimeInterval timerSec = 0.0;

@implementation Tools

+(GreyscaleImg *)convertUIImageToGreyscaleImg:(UIImage *)uiImg scaleToSize:(CGSize)scaledSize {
    CGImageRef imageRef = [uiImg CGImage];
    
    if (!imageRef)  return NULL;
    
//    const int w = CGImageGetWidth(imageRef);
//    const int h = CGImageGetHeight(imageRef);
//    const int channels = CGImageGetBytesPerRow(imageRef) / w;
//    
//    if (w <= 0 || h <= 0 || channels <= 0) return NULL;
    
    GreyscaleImg *gsImg = new GreyscaleImg;
    gsImg->w = scaledSize.width;
    gsImg->h = scaledSize.height;
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceGray();
    
    if (!colorSpace) return NULL;
    
    gsImg->bytes = (UInt8 *)malloc(gsImg->w * gsImg->h);
    
    CGContextRef context = CGBitmapContextCreate(gsImg->bytes, gsImg->w, gsImg->h,
                                                 8, gsImg->w, colorSpace,
                                                 kCGImageAlphaNone);
    
    CGColorSpaceRelease(colorSpace);
    
    if (!context) return NULL;
    
    CGContextDrawImage(context, CGRectMake(0, 0, gsImg->w, gsImg->h), imageRef);
    CGContextRelease(context);
    
    return gsImg;

}

+(UIImage *)convertGreyscaleImgToUIImage:(GreyscaleImg *)gsImg {
    // code from Patrick O'Keefe (http://www.patokeefe.com/archives/721)
    NSData *data = [NSData dataWithBytes:gsImg->bytes length:gsImg->w * gsImg->h];
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceGray();
    
    CGDataProviderRef provider = CGDataProviderCreateWithCFData((CFDataRef)data);
    
    // Creating CGImage from raw data
    CGImageRef imageRef = CGImageCreate(gsImg->w,                                 //width
                                        gsImg->h,                                 //height
                                        8,                                          //bits per component
                                        8,                       //bits per pixel
                                        gsImg->w,                            //bytesPerRow
                                        colorSpace,                                 //colorspace
                                        kCGImageAlphaNone|kCGBitmapByteOrderDefault,// bitmap info
                                        provider,                                   //CGDataProviderRef
                                        NULL,                                       //decode
                                        false,                                      //should interpolate
                                        kCGRenderingIntentDefault                   //intent
                                        );
    
    
    // Getting UIImage from CGImage
    UIImage *finalImage = [UIImage imageWithCGImage:imageRef];
    
    // cleanup
    CGImageRelease(imageRef);
    CGDataProviderRelease(provider);
    CGColorSpaceRelease(colorSpace);
    
    return finalImage;

}

// errornous!
//+(GreyscaleImg *)convertRawRGBAData:(UInt8 *)inData withWidth:(int)inW height:(int)inH toGreyScaleImgOfWidth:(int)outW height:(int)outH {
//    if (!inData) return NULL;
//    
//    // initialize greyscale image
//    GreyscaleImg *outImg = new GreyscaleImg;
//    outImg->w = outW;
//    outImg->h = outH;
//    outImg->bytes = new UInt8[outImg->w * outImg->h];
//    UInt8 * const outImgBytesPtr = outImg->bytes;
//    
//    // create block sizes for downsampling
//    const float sX = (float)inW / (float)outW;
//    const float sY = (float)inH / (float)outH;
//    const int bW = (int)ceilf(sX);
//    const int bH = (int)ceilf(sY);
//    const int blockSize = bW * bH;
////    const float oX = sX - bW;
////    const float oY = sY - bH;
//    const int inBPP = 4;    // bytes per pixel
//    const int inStride = inW * inBPP;
//    UInt8 * const inDataBasePtr = inData;
//    
//    // loop through the image data
//    for (int y = 0; y < outImg->h; y++) {   // for each out-image row
//        for (int x = 0; x < outImg->w; x++) {   // for each pixel in out-image row
//            const int blockMaxH = (y + bH > inH) ? inH : y + bH;
//            int blockSum = 0;
//            inData = inDataBasePtr + y * inStride;
//            for (int bY = y; bY < blockMaxH; bY++) {       // for each in-block row
//                const int blockMaxW = (x + bW > inW) ? inW : x + bW;
//                inData += (x * inBPP);
//                for (int bX = x; bX < blockMaxW; bX++) {       // for each pixel in in-block row
////                    UInt32 rgb = (*inBytes) & 0xFF;
////                    UInt32 rgba = *inData;
////                    NSLog(@"RGB = %d, %d, %d", *inData, *(inData + 1), *(inData + 2));
//                    blockSum += GREY_VALUE_FROM_RGB_VALUE(inData);  // add current value to overall block grey value sum
//                    inData += inBPP;    // increment pointer for in-data to go to next pixel in current row
//                }
//                
//                inData += inStride; // increment pointer for in-data to go to next row
//            }
//            
//            *outImg->bytes = (UInt8)(blockSum / blockSize); // set out-data pixel
//            outImg->bytes++;    // increment pointer for out-data
//        }
//    }
//    
//    // reset pointer
//    outImg->bytes = outImgBytesPtr;
//    
//    return outImg;
//}

+(GreyscaleImg *)convertRawRGBADataToGreyscaleImg:(UInt8 *)inData withWidth:(int)inW height:(int)inH {
    if (!inData) return NULL;
    
    // initialize greyscale image
    GreyscaleImg *outImg = new GreyscaleImg;
    outImg->w = inW;
    outImg->h = inH;
    outImg->bytes = new UInt8[outImg->w * outImg->h];
    UInt8 * const outImgBytesPtr = outImg->bytes;
    const int inBPP = 4;    // bytes per pixel
    
    // loop through the image data
    const unsigned int s = inW * inH;
    for (unsigned int i = 0; i < s; i++) {   // for each out-image row
        *outImg->bytes = GREY_VALUE_FROM_RGB_VALUE(inData);
        outImg->bytes++;
        inData += inBPP;
    }
    
    // reset pointers
    outImg->bytes = outImgBytesPtr;
    
    return outImg;
}

+(void)timerStart {
    timerSec = CACurrentMediaTime();
}

+(NSTimeInterval)timerStop {
    return CACurrentMediaTime() - timerSec;
}

@end
