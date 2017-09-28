//
//  ARSphereManager.m
//  RCTARKit
//
//  Created by Zehao Li on 8/16/17.
//  Copyright © 2017 HippoAR. All rights reserved.
//

#import "ARSphereManager.h"
#import "RCTARKitGeos.h"
#import "RCTARKitNodes.h"

@implementation ARSphereManager

RCT_EXPORT_MODULE()

RCT_EXPORT_METHOD(mount:(NSDictionary *)property material:(SCNMaterial *)material) {
    [[RCTARKitGeos sharedInstance] addSphere:property material:material];
}

RCT_EXPORT_METHOD(unmount:(NSString *)identifier) {
    [[RCTARKitNodes sharedInstance] removeNodeForKey:identifier];
}

@end
