//
//  ARPlaneManager.m
//  RCTARKit
//
//  Created by Zehao Li on 8/16/17.
//  Copyright © 2017 HippoAR. All rights reserved.
//

#import "ARPlaneManager.h"
#import "RCTARKit.h"
#import "RCTARKitNodes.h"

@implementation ARPlaneManager

RCT_EXPORT_MODULE()

RCT_EXPORT_METHOD(mount:(NSDictionary *)property) {
    [[ARKit sharedInstance] addPlane:property];
}

RCT_EXPORT_METHOD(unmount:(NSString *)identifier) {
    [[RCTARKitNodes sharedInstance] removeNodeForKey:identifier];
}

@end
