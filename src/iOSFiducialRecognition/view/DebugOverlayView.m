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
//  DebugOverlayView.m
//  IslARWallApp
//
//  Created by Markus Konrad on 14.03.13.
//  Copyright (c) 2013 INKA Research Group. All rights reserved.
//

#import "DebugOverlayView.h"

@implementation DebugOverlayView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setOpaque:NO];
        
        pointsToDisplay = [[NSMutableDictionary alloc] init];
    }
    return self;
}

-(void)dealloc {
    [pointsToDisplay release];
    
    [super dealloc];
}

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();

    for (UIColor *c in [pointsToDisplay allKeys]) {
        // set color
        UIColor *c2 = [c colorWithAlphaComponent:0.25f];
        CGContextSetFillColorWithColor(ctx, c2.CGColor);
        CGContextSetStrokeColorWithColor(ctx, c2.CGColor);
        CGContextSetLineWidth(ctx, 2.0);
        
        // display the points for the color
        NSArray *array = [pointsToDisplay objectForKey:c];
        for (NSValue *v in array) {
            if (strcmp([v objCType], @encode(CGRect)) == 0) {
                CGRect r = [v CGRectValue];
                CGContextAddEllipseInRect(ctx, r);
                CGContextFillPath(ctx);
            } else if (strcmp([v objCType], @encode(CGPoint)) == 0) {
                CGPoint p = [v CGPointValue];
                CGContextFillRect(ctx, CGRectMake(p.x - 1, p.y - 1, 3, 3));
            }
        }
    }
}

- (void)displayImage:(UIImage *)img inRect:(CGRect)rect {
    UIImageView *imgView = [[[UIImageView alloc] initWithImage:img] autorelease];
    [imgView setFrame:rect];
    
    [self addSubview:imgView];
}

//-(void)displayKeyPoints:(vector<cv::KeyPoint>&)keypts fromImageOfSize:(CGSize)size inColor:(UIColor *)c {
//    const float sx = self.frame.size.width / size.width;
//    const float sy = self.frame.size.height / size.height;
//    
//    // construct point array
//    NSMutableArray *array = [NSMutableArray arrayWithCapacity:keypts.size()];
//    for (vector<cv::KeyPoint>::iterator it = keypts.begin(); it != keypts.end(); ++it) {
//        float rad = sx * it->size;
//        CGRect r = CGRectMake(sx * it->pt.x - rad / 2, sy * it->pt.y - rad / 2, rad, rad);
//        [array addObject:[NSValue valueWithCGRect:r]];
//    }
//    
//    // set the point array
//    [pointsToDisplay setObject:array forKey:c];
//    
//    // update
//    [self setNeedsDisplay];
//}
//
//-(void)displayPoints:(vector<cv::Point2f>&)pts fromImageOfSize:(CGSize)size inColor:(UIColor *)c {
//    const float sx = self.frame.size.width / size.width;
//    const float sy = self.frame.size.height / size.height;
//    
//    // construct point array
//    NSMutableArray *array = [NSMutableArray arrayWithCapacity:pts.size()];
//    for (vector<cv::Point2f>::iterator it = pts.begin(); it != pts.end(); ++it) {
//        CGPoint p = {sx * it->x, sy * it->y};
//        [array addObject:[NSValue valueWithCGPoint:p]];
//    }
//    
//    // set the point array
//    [pointsToDisplay setObject:array forKey:c];
//    
//    // update
//    [self setNeedsDisplay];
//}

@end
