//
//  ARModelManager.m
//  RCTARKit
//
//  Created by Zehao Li on 8/12/17.
//  Copyright © 2017 HippoAR. All rights reserved.
//

#import "ARModelManager.h"
#import "RCTARKitNodes.h"
#import "RCTARKitIO.h"

@implementation ARModelManager

RCT_EXPORT_MODULE()

RCT_EXPORT_METHOD(mount:(NSDictionary *)property node:(SCNNode *)node) {
    NSDictionary *model = property[@"model"];
    CGFloat scale = [model[@"scale"] floatValue];
    
    NSString *path = [NSString stringWithFormat:@"%@", model[@"file"]];
    SCNNode *modelNode = [[RCTARKitIO sharedInstance] loadModel:path nodeName:model[@"node"] withAnimation:YES];
    modelNode.scale = SCNVector3Make(scale, scale, scale);
    
    [node addChildNode:modelNode];
    [[RCTARKitNodes sharedInstance] addNodeToScene:node];
}

@end
