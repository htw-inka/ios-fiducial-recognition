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
//  OverlayRegion.m
//  IslARWallFidu
//
//  Created by Markus Konrad on 12.04.13.
//  Copyright (c) 2013 INKA Research Group. All rights reserved.
//

#import "OverlayRegion.h"

#define UPD_VIEW [self setNeedsDisplay];[CATransaction flush];

@interface OverlayRegion ()
-(void)updateColors;
@end

@implementation OverlayRegion

@synthesize anim;
@synthesize markerId;
@synthesize active;

#pragma mark init/dealloc methods

+(id)overlayRegionWithMarkerId:(int)mId initialRect:(CGRect)r {
    return [[[OverlayRegion alloc] initWithMarkerId:mId initialRect:r] autorelease];
}

-(id)initWithMarkerId:(int)mId initialRect:(CGRect)r {
    if ((self = [super init])) {
        // set marker id
        markerId = mId;
        
        // set frame
        [self setFrame:r];
        
        // set color
        baseColor = CGColorRetain([UIColor greenColor].CGColor);
        activeColor = CGColorRetain([UIColor redColor].CGColor);
        baseColorBG = CGColorCreateCopyWithAlpha([UIColor greenColor].CGColor, 0.5f);
        activeColorBG = CGColorCreateCopyWithAlpha([UIColor redColor].CGColor, 0.5f);
        
        curColor = &baseColor;
        curColorBG = &baseColorBG;
        
        [self setActive:NO];
        
        // create animation
        anim = [[CABasicAnimation alloc] init];
        [anim setDuration:0.3f];
        [self addAnimation:anim forKey:@"frame"];
    }
    
    return self;
}

-(void)dealloc {
    CGColorRelease(baseColor);
    CGColorRelease(activeColor);
    CGColorRelease(baseColorBG);
    CGColorRelease(activeColorBG);
    
    [anim release];
    
    [super dealloc];
}

#pragma mark parent methods

-(void)drawInContext:(CGContextRef)ctx {    
    [super drawInContext:ctx];

    // set fill color & stroke width
    CGContextSetLineWidth(ctx, 1.0);
    CGContextSetFillColorWithColor(ctx, *curColor);
    CGContextSetStrokeColorWithColor(ctx, *curColor);
    
    // set font
    CGContextSelectFont(ctx, "Courier New", 14, kCGEncodingMacRoman);
    CGContextSetCharacterSpacing(ctx, 1);
    CGContextSetTextDrawingMode(ctx, kCGTextFillStroke);
    
    // flip view matrix for text
    CGAffineTransform flipTransform = CGAffineTransformConcat(CGAffineTransformMakeTranslation(0.f, self.bounds.size.height),
                                                              CGAffineTransformMakeScale(1.f, -1.f));
    
    CGContextSetTextMatrix(ctx, flipTransform);
    
    // draw text
    NSString *s = [NSString stringWithFormat:@"%d", markerId];
    CGContextShowTextAtPoint(ctx, self.frame.size.width / 2.0f, self.frame.size.height / 2.0f,
                             [s cStringUsingEncoding:NSASCIIStringEncoding], s.length);
    
}

#pragma mark public methods

-(void)updateRect:(CGRect)r inAnimationInterval:(CFTimeInterval)sec {
    [anim setDuration:sec];
    [self setFrame:r];
    
    UPD_VIEW;
}

-(BOOL)toggleActive {
    active = !active;
    
    [self updateColors];
    
    return active;
}

-(void)setActive:(BOOL)state {
    active = state;
    
    [self updateColors];
}

#pragma mark private methods

-(void)updateColors {
    if (active) {
        curColor = &activeColor;
        curColorBG = &activeColorBG;
    } else {
        curColor = &baseColor;
        curColorBG = &baseColorBG;
    }
    
    [self setBackgroundColor:*curColorBG];
    
    UPD_VIEW;
}

@end
