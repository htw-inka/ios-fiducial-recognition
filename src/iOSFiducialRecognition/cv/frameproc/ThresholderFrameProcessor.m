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
