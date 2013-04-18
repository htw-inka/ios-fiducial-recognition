//
//  OverlayRegion.h
//  IslARWallFidu
//
//  Created by Markus Konrad on 12.04.13.
//  Copyright (c) 2013 INKA Research Group. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

@interface OverlayRegion : CALayer {
    CGColorRef baseColor;
}

@property (nonatomic, readonly) CABasicAnimation *anim;
@property (nonatomic, assign) int markerId;

+(id)overlayRegionWithMarkerId:(int)mId initialRect:(CGRect)r;

-(id)initWithMarkerId:(int)mId initialRect:(CGRect)r;

-(void)updateRect:(CGRect)r inAnimationInterval:(CFTimeInterval)sec;

@end
