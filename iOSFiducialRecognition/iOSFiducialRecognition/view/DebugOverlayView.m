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
