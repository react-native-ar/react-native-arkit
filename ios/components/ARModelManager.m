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

RCT_EXPORT_METHOD(mount:(NSDictionary *)property node:(SCNNode *)node frame:(NSString *)frame) {
    NSDictionary *model = property[@"model"];
    CGFloat scale = [model[@"scale"] floatValue];
    
    NSString *path = [NSString stringWithFormat:@"%@", model[@"file"]];
    SCNNode *modelNode = [[RCTARKitIO sharedInstance] loadModel:path nodeName:model[@"node"] withAnimation:YES];
    modelNode.scale = SCNVector3Make(scale, scale, scale);
    NSDictionary *materialShaders;
    NSDictionary *geometryShaders;
    
    
    if(property[@"material"] ) {
        NSDictionary* material = property[@"material"];
        if(material[@"shaders"] ) {
            materialShaders = material[@"shaders"];
        }
    }
    if(property[@"shape"] ) {
        NSDictionary* shape = property[@"shape"];
        if(shape[@"shaders"] ) {
            geometryShaders = shape[@"shaders"];
        }
    }
    
    
    if(geometryShaders) {
        node.geometry.shaderModifiers = geometryShaders;
    }
    if(materialShaders) {
        for(id idx in node.geometry.materials) {
            SCNMaterial* material = (SCNMaterial* )idx;
            material.shaderModifiers = materialShaders;
        }
    }
    
    for(id idx in modelNode.childNodes) {
        // iterate over all childnodes and apply shaders
        SCNNode* node = (SCNNode *)idx;
        if(geometryShaders) {
            node.geometry.shaderModifiers = geometryShaders;
        }
        if(materialShaders) {
            for(id idx in node.geometry.materials) {
                SCNMaterial* material = (SCNMaterial* )idx;
                material.shaderModifiers = materialShaders;
            }
        }
    
    }
    [node addChildNode:modelNode];
    [[RCTARKitNodes sharedInstance] addNodeToScene:node inReferenceFrame:frame];
}

@end
