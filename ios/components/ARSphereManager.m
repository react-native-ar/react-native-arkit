//
//  ARSphereManager.m
//  RCTARKit
//
//  Created by Zehao Li on 8/16/17.
//  Copyright © 2017 HippoAR. All rights reserved.
//

#import "ARSphereManager.h"
#import "RCTARKit.h"
#import "RCTARKitGeos.h"
#import "RCTARKitNodes.h"

@implementation ARSphereManager

RCT_EXPORT_MODULE()

RCT_EXPORT_METHOD(mount:(NSDictionary *)property) {
    [[RCTARKitGeos sharedInstance] addSphere:property];
}

RCT_EXPORT_METHOD(unmount:(NSString *)identifier) {
    [[RCTARKitNodes sharedInstance] removeNodeForKey:identifier];
}

@end
