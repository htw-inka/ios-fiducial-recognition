//
//  Singleton.h
//  IslARWallApp
//
//  Created by Markus Konrad on 14.03.13.
//  Copyright (c) 2013 INKA Research Group. All rights reserved.
//

#ifndef IslARWallApp_Singleton_h
#define IslARWallApp_Singleton_h

#import <Foundation/Foundation.h>

// Declares a standard singleton interface
@protocol Singleton <NSObject>

// "shared" method. Each singleton gives access to its object with this method.
+ (id)shared;

// This method destroys the singleton and frees its memory.
+ (void)destroy;

@end

#endif
