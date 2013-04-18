//
//  DebugOverlayView.h
//  IslARWallApp
//
//  Created by Markus Konrad on 14.03.13.
//  Copyright (c) 2013 INKA Research Group. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DebugOverlayView : UIView {
    NSMutableDictionary *pointsToDisplay;   // with mapping UIColor -> NSMutableArray of CGPoints
}

-(void)displayImage:(UIImage *)img inRect:(CGRect)rect;
//-(void)displayKeyPoints:(vector<cv::KeyPoint>&)keypts fromImageOfSize:(CGSize)size inColor:(UIColor *)c;
//-(void)displayPoints:(vector<cv::Point2f>&)pts fromImageOfSize:(CGSize)size inColor:(UIColor *)c;

@end
