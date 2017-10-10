//
//  ARModelManager.m
//  RCTARKit
//
//  Created by Zehao Li on 8/12/17.
//  Copyright © 2017 HippoAR. All rights reserved.
//

#import "ARLightManager.h"
#import "RCTARKitNodes.h"
#import "RCTConvert+ARKit.h"

@implementation ARLightManager

RCT_EXPORT_MODULE()

RCT_EXPORT_METHOD(mount:(NSDictionary *)property node:(SCNNode *)node frame:(NSString *)frame) {
    //NSLog(@"mount light"); 
    //[node addChildNode:lightNode];
    [[RCTARKitNodes sharedInstance] addNodeToScene:node inReferenceFrame:frame];
}

@end
