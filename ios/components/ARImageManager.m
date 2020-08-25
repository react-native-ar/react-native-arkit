//
//  ARImageManager.m
//  RCTARKit
//
//  Created by Zehao Li on 8/12/17.
//  Copyright © 2017 HippoAR. All rights reserved.
//

#import "ARImageManager.h"
#import "RCTARKitNodes.h"
#import "RCTConvert+ARKit.h"

@implementation ARImageManager

RCT_EXPORT_MODULE()

RCT_EXPORT_METHOD(mount:(SCNImageNode*)imageNode node:(SCNNode *)node frame:(NSString *)frame parentId:(NSString *)parentId) {
    [node addChildNode:imageNode];
    [[RCTARKitNodes sharedInstance] addNodeToScene:node inReferenceFrame:frame withParentId:parentId];
}

@end
