//
//  FrameProcessor.h
//  IslARWallFidu
//
//  Created by Markus Konrad on 29.03.13.
//  Copyright (c) 2013 INKA Research Group. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "cv_types.h"

@protocol FrameProcessor <NSObject>

@required
-(GreyscaleImg *)processImage:(GreyscaleImg *)img;

@end
