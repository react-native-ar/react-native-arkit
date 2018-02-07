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
#import "RCTConvert+ARKit.h"

@implementation ARModelManager

RCT_EXPORT_MODULE()

RCT_EXPORT_METHOD(mount:(NSDictionary *)property node:(SCNNode *)node frame:(NSString *)frame) {
    //NSLog(@"mounting node: %@ ", node.name);
    // we need to mount first, otherwise, if the loading of the model is slow, it will be registered too late
    [[RCTARKitNodes sharedInstance] addNodeToScene:node inReferenceFrame:frame];
    // we need to do the model loading in its own queue, otherwise it can block, so that react-to-native-calls get out of order
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSDictionary *model = property[@"model"];
        CGFloat scale = 1;
        if(model[@"scale"]) {
            // deprecated
            scale = [model[@"scale"] floatValue];
        }
        
        NSString *path = [NSString stringWithFormat:@"%@", model[@"file"]];
        //NSLog(@"mounting model: %@ %@", node.name, path);
        SCNNode *modelNode = [[RCTARKitIO sharedInstance] loadModel:path nodeName:model[@"node"] withAnimation:YES];
        modelNode.scale = SCNVector3Make(scale, scale, scale);
        // transfer some properties to modeNode like "castsShadow"
        modelNode.castsShadow = node.castsShadow;
        
        
        NSDictionary* materialJson;
        if(property[@"material"] ) {
            materialJson = property[@"material"];
        }
        
        
        if(materialJson) {
            for(id idx in modelNode.geometry.materials) {
                SCNMaterial* material = (SCNMaterial* )idx;
                [RCTConvert setMaterialProperties:material properties:materialJson];
            }
        }
        
        for(id idx in modelNode.childNodes) {
            // iterate over all childnodes and apply shaders
            
            SCNNode* childNode = (SCNNode *)idx;
            childNode.castsShadow = node.castsShadow;
            if(materialJson) {
                for(id idx in childNode.geometry.materials) {
                    SCNMaterial* material = (SCNMaterial* )idx;
                    [RCTConvert setMaterialProperties:material properties:materialJson];
                }
            }
            
        }
        [node addChildNode:modelNode];
        //NSLog(@"load model finished: %@", node.name);
    });
    
    
}

@end
