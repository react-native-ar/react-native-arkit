//
//  ARCapsuleManager.m
//  RCTARKit
//
//  Created by Zehao Li on 8/16/17.
//  Copyright © 2017 HippoAR. All rights reserved.
//

#import "ARCapsuleManager.h"
#import "RCTARKit.h"

@implementation ARCapsuleManager

RCT_EXPORT_MODULE()

RCT_EXPORT_METHOD(mount:(NSDictionary *)property) {
    [[ARKit sharedInstance] addCapsule:property];
}

RCT_EXPORT_METHOD(unmount:(NSString *)identifier) {
    [[ARKit sharedInstance] removeNodeForKey:identifier];
}

@end
