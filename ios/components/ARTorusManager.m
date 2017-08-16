//
//  ARTorusManager.m
//  RCTARKit
//
//  Created by Zehao Li on 8/16/17.
//  Copyright © 2017 HippoAR. All rights reserved.
//

#import "ARTorusManager.h"
#import "RCTARKit.h"

@implementation ARTorusManager

RCT_EXPORT_MODULE()

RCT_EXPORT_METHOD(mount:(NSDictionary *)property) {
    [[ARKit sharedInstance] addTorus:property];
}

RCT_EXPORT_METHOD(unmount:(NSString *)identifier) {
    [[ARKit sharedInstance] removeNodeForKey:identifier];
}

@end
