//
//  OverlayRegion.m
//  IslARWallFidu
//
//  Created by Markus Konrad on 12.04.13.
//  Copyright (c) 2013 INKA Research Group. All rights reserved.
//

#import "OverlayRegion.h"

@implementation OverlayRegion

@synthesize anim;
@synthesize markerId;

#pragma mark public methods

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
        [self setBackgroundColor:CGColorCreateCopyWithAlpha(baseColor, 0.5f)];
        [self setBorderColor:baseColor];
        
        // create animation
        anim = [[CABasicAnimation alloc] init];
        [anim setDuration:0.3f];
        [self addAnimation:anim forKey:@"frame"];
    }
    
    return self;
}

-(void)dealloc {
    CGColorRelease(baseColor);
    
    [anim release];
    
    [super dealloc];
}

-(void)updateRect:(CGRect)r inAnimationInterval:(CFTimeInterval)sec {
    [anim setDuration:sec];
    [self setFrame:r];
    
    [self setNeedsDisplay];
}

-(void)drawInContext:(CGContextRef)ctx {    
    [super drawInContext:ctx];

    // set fill color & stroke width
    CGContextSetLineWidth(ctx, 1.0);
    CGContextSetFillColorWithColor(ctx, baseColor);
    CGContextSetStrokeColorWithColor(ctx, baseColor);
    
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

@end
