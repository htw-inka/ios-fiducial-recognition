//
//  TrackableObject.h
//  IslARWallApp
//
//  Created by Markus Konrad on 22.03.13.
//  Copyright (c) 2013 INKA Research Group. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "OverlayRegion.h"

#define FIDUCIAL_LOST 0
#define FIDUCIAL_FOUND 1
#define FIDUCIAL_INVALID 2
#define FIDUCIAL_WRONG 3
#define FIDUCIAL_REGION 4

@interface TrackableObject : NSObject {
	int id_buffer[6];
	short id_buffer_index;
    int lost_frames;
//    CGPoint prevPos;
//    float prevAngle;
}

@property (nonatomic, readonly) int markerId;
@property (nonatomic, readonly) int sessId;
@property (nonatomic, readonly) int nodeCount;
@property (nonatomic, readonly) CGPoint pos;
@property (nonatomic, readonly) float angle;
@property (nonatomic, readonly) float rootSize;
@property (nonatomic, readonly) float leafSize;
@property (nonatomic, readonly) int rootColor;
@property (nonatomic, assign) int state;    // one of the FIDUCIAL_* makro define values
@property (nonatomic, assign) BOOL updated;
@property (nonatomic, readonly) NSTimeInterval lastDetection;
@property (nonatomic, retain) OverlayRegion *overlayRegion;

-(id)initWithMarkerId:(int)mId sessId:(int)sId rootColor:(int)rootClr nodeCount:(int)nCount;

//+(TrackableObject *)trackableObjectWithMarkerId:(int)markerId;
+(TrackableObject *)trackableObjectWithMarkerId:(int)mId sessId:(int)sId rootColor:(int)rootClr nodeCount:(int)nCount;

-(float)distToX:(float)x Y:(float)y;

-(void)updateWithX:(float)x Y:(float)y angle:(float)a rootSize:(float)rSize leafSize:(float)lSize;

// NOTE:
// This method mainly consists of code from the reacTIVision open-source project (reactivision.sourceforge.net)
// All credits go to the creators of reacTIVision.
-(BOOL)checkIdConflictUsingSessId:(int)s_id andMarkerId:(int)f_id;

// check if the fiducial is still alive
-(BOOL)isAlive;

@end
