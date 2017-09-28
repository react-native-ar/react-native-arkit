//
//  RCTConvert+ARKit.h
//  RCTARKit
//
//  Created by Zehao Li on 9/28/17.
//  Copyright © 2017 HippoAR. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <SceneKit/SceneKit.h>
#import <React/RCTConvert.h>

@interface RCTConvert (ARKit)

+ (SCNMaterial *)SCNMaterial:(id)json;

@end

