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