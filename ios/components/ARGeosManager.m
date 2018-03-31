//
//  ARGeosManager.m
//  RCTARKit
//
//  Created by Zehao Li on 9/28/17.
//  Copyright © 2017 HippoAR. All rights reserved.
//

#import "ARGeosManager.h"
#import "RCTARKitNodes.h"



@implementation ARGeosManager

RCT_EXPORT_MODULE()



RCT_EXPORT_METHOD(mount:(SCNGeometry *)geometry node:(SCNNode *)node frame:(NSString *)frame parentId:(NSString *)parentId resolve:(RCTPromiseResolveBlock)resolve reject:(RCTPromiseRejectBlock)reject ) {
    [self addNodeWithGeometry:node geometry:geometry frame:frame  parentId:parentId];
    resolve(nil);
}


RCT_EXPORT_METHOD(addLight:(SCNLight *)light node:(SCNNode *)node frame:(NSString *)frame parentId:(NSString *)parentId resolve:(RCTPromiseResolveBlock)resolve reject:(RCTPromiseRejectBlock)reject) {
    node.light = light;
    [self addNodeWithGeometry:node geometry:nil frame:frame parentId:parentId];
    resolve(nil);
}


RCT_EXPORT_METHOD(unmount:(NSString *)identifier) {
    //NSLog(@"unmounting node: %@ ", identifier);
    [[RCTARKitNodes sharedInstance] removeNode:identifier];
}

RCT_EXPORT_METHOD(updateNode:(NSString *)identifier properties:(NSDictionary *) properties resolve:(RCTPromiseResolveBlock)resolve reject:(RCTPromiseRejectBlock)reject) {
    //NSLog(@"updating node: %@ ", identifier);
    bool success = [[RCTARKitNodes sharedInstance] updateNode:identifier properties:properties];
    if(success) {
        resolve(nil);
    } else {
        reject(@"updateNodeError", @"could not update node", nil);
    }
}

- (void)addNodeWithGeometry:(SCNNode *)node geometry:(SCNGeometry *)geometry frame:(NSString *)frame parentId:(NSString *)parentId {
    if(geometry) {
        node.geometry = geometry;
        // usually, scenekit will use the same geometry for physicsshape,
        // if you assign a physicsBody without a shape.
        // but because we create SCNNode and the geometry indipendently, scenekit will know the geometry, so we add it here manually
        if(node.physicsBody && ! node.physicsBody.physicsShape) {
            node.physicsBody.physicsShape = [SCNPhysicsShape shapeWithGeometry:geometry options:nil];
        }
    }
    [[RCTARKitNodes sharedInstance] addNodeToScene:node inReferenceFrame:frame withParentId:parentId];
    
}

@end



