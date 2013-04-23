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
//  Config.h
//  IslARWallApp
//
//  Created by Markus Konrad on 13.03.13.
//  Copyright (c) 2013 INKA Research Group. All rights reserved.
//

#ifndef IslARWallApp_Config_h
#define IslARWallApp_Config_h

// Is the app supposed to run in portrait view
#define VIDEOCAPTUREORIENTATION AVCaptureVideoOrientationLandscapeRight
#define PORTRAIT 0

// Camera capture quality
#define CAMERA_VIEW_QUALITY AVCaptureSessionPreset1280x720
//#define CAMERA_VIEW_QUALITY AVCaptureSessionPresetHigh
#define CAMERA_VIEW_RESIZE_MODE AVLayerVideoGravityResizeAspect


// Camera capture rate in seconds
//#define CAMERA_CAPTURE_RATE (1.0f/10.0f)

// Tracker
#define TRACKER_IMAGE_W 1024
//#define TRACKER_IMAGE_H 768
#define TRACKER_IMAGE_H 576 // for 16:9 input

// Overlay
#define OVERLAY_ROI_SCALING_FACTOR 0.6f

// Debug

#define DEBUG_ENABLE_STATS
#define DEBUG_SIMULATOR_TESTIMG_SCENE @"testscene1.jpg"


#endif
