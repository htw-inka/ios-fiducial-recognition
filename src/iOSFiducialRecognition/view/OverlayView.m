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
//  OverlayView.m
//  IslARWallApp
//
//  Created by Markus Konrad on 14.03.13.
//  Copyright (c) 2013 INKA Research Group. All rights reserved.
//

#import "OverlayView.h"

#define RECT_AT_CENTER(x, y, r) CGRectMake(x-r, y-r, 2*r, 2*r)

@interface OverlayView()
-(CGRect)rectForTrackableObject:(TrackableObject *)obj;
@end

@implementation OverlayView

@synthesize previewLayerRef;

#pragma mark init/dealloc

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setOpaque:NO];
        tracker = [Tracker shared];
        detectedObjects = [[NSMutableDictionary alloc] init];
    }
    return self;
}

-(void)dealloc {
    [detectedObjects release];
    [previewLayerRef release];
    
    [super dealloc];
}

#pragma mark parent methods

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();

    // set fill color & stroke width
    CGContextSetStrokeColorWithColor(ctx, [UIColor redColor].CGColor);
    CGContextSetLineWidth(ctx, 1.0);
    CGContextSetFillColorWithColor(ctx, [UIColor redColor].CGColor);
    
    // set font
    CGContextSelectFont(ctx, "Courier New", 14, kCGEncodingMacRoman);
    CGContextSetCharacterSpacing(ctx, 1);
    CGContextSetTextDrawingMode(ctx, kCGTextFillStroke);
    
    // flip view matrix for text
    CGAffineTransform flipTransform = CGAffineTransformConcat(CGAffineTransformMakeTranslation(0.f, self.bounds.size.height),
                                                              CGAffineTransformMakeScale(1.f, -1.f));
    
    CGContextSetTextMatrix(ctx, flipTransform);
    
    // draw lines around each object
//    NSLog(@"OverlayView: Drawing %d objects", detectedObjects.count);
    for (TrackableObject *obj in [detectedObjects allValues]) {
#if (TARGET_IPHONE_SIMULATOR == 0)
        // calculate the objects position on the view
        // first create a point in the scale of 0.0 to 1.0 for the AVCapturePreviewLayer method...
        CGPoint pointInVideo = { obj.pos.x / frameSize.width, obj.pos.y / frameSize.height };
        // ... which is used here to convert it to absolute pixel values for the view
        CGPoint p = [previewLayerRef pointForCaptureDevicePointOfInterest:pointInVideo];
#else
        CGPoint p = { obj.pos.x * objPointScaling.x, obj.pos.y * objPointScaling.y };
#endif
        
        // show a little rectangle
        CGContextAddRect(ctx, RECT_AT_CENTER(p.x, p.y, 3));
        
        // show the id
        NSString *s = [NSString stringWithFormat:@"%d", obj.markerId];
        CGContextShowTextAtPoint(ctx, p.x + 4, p.y + 4, [s cStringUsingEncoding:NSASCIIStringEncoding], s.length);
    }
    
    // fill all the objects
    CGContextFillPath(ctx);
}

#pragma mark TrackerDelegate methods

-(void)tracker:(Tracker *)tracker grabbedInitialFrameOfSize:(CGSize)fSize {
    frameSize = fSize;
    objPointScaling = CGPointMake(self.frame.size.width / frameSize.width, self.frame.size.height / frameSize.height);
    NSLog(@"OverlayView: Frame size is %d x %d -> scaling is %f x %f", (int)frameSize.width, (int)frameSize.height, objPointScaling.x, objPointScaling.y);
}

-(void)tracker:(Tracker *)tracker foundObject:(TrackableObject *)obj {
//    NSLog(@"OverlayView: Found object: %@", obj);
    
    OverlayRegion *objRegion = [OverlayRegion overlayRegionWithMarkerId:obj.markerId
                                                            initialRect:[self rectForTrackableObject:obj]];
    [obj setOverlayRegion:objRegion];
    [self.layer addSublayer:objRegion];
    [objRegion setNeedsDisplay];
    
    [detectedObjects setObject:obj forKey:[NSNumber numberWithInt:obj.markerId]];
}

-(void)tracker:(Tracker *)t tracedObject:(TrackableObject *)obj {
//    NSLog(@"OverlayView: Traced object: %@", obj);
    
    [obj.overlayRegion updateRect:[self rectForTrackableObject:obj]
              inAnimationInterval:tracker.lastTrackingLoopTime];
}

-(void)tracker:(Tracker *)tracker lostObject:(TrackableObject *)obj {
//    NSLog(@"OverlayView: Lost object: %@", obj);
    
    [obj.overlayRegion removeFromSuperlayer];
    [obj setOverlayRegion:NULL];
    
    [detectedObjects removeObjectForKey:[NSNumber numberWithInt:obj.markerId]];
}

#pragma mark private methods

-(CGRect)rectForTrackableObject:(TrackableObject *)obj {
#if (TARGET_IPHONE_SIMULATOR == 0)
    // calculate the objects position on the view
    // first create a point in the scale of 0.0 to 1.0 for the AVCapturePreviewLayer method...
    CGPoint pointInVideo = { obj.pos.x / frameSize.width, obj.pos.y / frameSize.height };
    // ... which is used here to convert it to absolute pixel values for the view
    CGPoint p = [previewLayerRef pointForCaptureDevicePointOfInterest:pointInVideo];
#else
    CGPoint p = { obj.pos.x * objPointScaling.x, obj.pos.y * objPointScaling.y };
#endif
    
    return RECT_AT_CENTER(p.x, p.y, obj.rootSize * OVERLAY_ROI_SCALING_FACTOR);
}

@end
