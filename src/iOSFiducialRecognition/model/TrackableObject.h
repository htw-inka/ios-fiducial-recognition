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
