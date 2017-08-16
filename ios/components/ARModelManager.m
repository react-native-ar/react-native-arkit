//
//  ARModelManager.m
//  RCTARKit
//
//  Created by Zehao Li on 8/12/17.
//  Copyright © 2017 HippoAR. All rights reserved.
//

#import "ARModelManager.h"
#import "RCTARKit.h"

@implementation ARModelManager

RCT_EXPORT_MODULE()

RCT_EXPORT_METHOD(mount:(NSDictionary *)property) {
    [[ARKit sharedInstance] addModel:property];
}

RCT_EXPORT_METHOD(unmount:(NSString *)identifier) {
    [[ARKit sharedInstance] removeNodeForKey:identifier];
}

@end
