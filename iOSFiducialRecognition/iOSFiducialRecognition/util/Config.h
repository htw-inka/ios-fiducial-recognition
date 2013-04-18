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
