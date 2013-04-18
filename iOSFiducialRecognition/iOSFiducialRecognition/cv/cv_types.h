//
//  cv_types.h
//  IslARWallFidu
//
//  Created by Markus Konrad on 29.03.13.
//  Copyright (c) 2013 INKA Research Group. All rights reserved.
//

#ifndef IslARWallFidu_cv_types_h
#define IslARWallFidu_cv_types_h

typedef struct _GreyscaleImg {
    unsigned int w;
    unsigned int h;
    UInt8 *bytes;
    _GreyscaleImg() { w = 0; h = 0; bytes = NULL; }
    ~_GreyscaleImg() { if (bytes) free(bytes); }
} GreyscaleImg;


#endif
