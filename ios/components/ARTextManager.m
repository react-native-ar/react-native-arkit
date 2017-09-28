//
//  ARTextManager.m
//  RCTARKit
//
//  Created by Zehao Li on 8/12/17.
//  Copyright © 2017 HippoAR. All rights reserved.
//

#import "ARTextManager.h"
#import "RCTARKitGeos.h"
#import "RCTARKitNodes.h"

@implementation ARTextManager

RCT_EXPORT_MODULE()

RCT_EXPORT_METHOD(mount:(NSDictionary *)property material:(SCNMaterial *)material) {
    [[RCTARKitGeos sharedInstance] addText:property material:material];
}

RCT_EXPORT_METHOD(unmount:(NSString *)identifier) {
    [[RCTARKitNodes sharedInstance] removeNodeForKey:identifier];
}

@end
