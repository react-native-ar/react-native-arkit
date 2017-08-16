//
//  ARTubeManager.m
//  RCTARKit
//
//  Created by Zehao Li on 8/16/17.
//  Copyright © 2017 HippoAR. All rights reserved.
//

#import "ARTubeManager.h"
#import "RCTARKit.h"

@implementation ARTubeManager

RCT_EXPORT_MODULE()

RCT_EXPORT_METHOD(mount:(NSDictionary *)property) {
    [[ARKit sharedInstance] addTube:property];
}

RCT_EXPORT_METHOD(unmount:(NSString *)identifier) {
    [[ARKit sharedInstance] removeNodeForKey:identifier];
}

@end
