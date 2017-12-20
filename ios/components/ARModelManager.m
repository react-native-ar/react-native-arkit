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

    // we need to mount first, otherwise, if the loading of the model is slow, it will be registered too late
    [[RCTARKitNodes sharedInstance] addNodeToScene:node inReferenceFrame:frame];
    // we need to do the model loading in its own queue, otherwise it can block, so that react-to-native-calls get out of order
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSDictionary *model = property[@"model"];
        CGFloat scale = [model[@"scale"] floatValue];
        
        NSString *path = [NSString stringWithFormat:@"%@", model[@"file"]];
        //NSLog(@"mounting model: %@ %@", node.name, path);
        SCNNode *modelNode = [[RCTARKitIO sharedInstance] loadModel:path nodeName:model[@"node"] withAnimation:YES];
        modelNode.scale = SCNVector3Make(scale, scale, scale);
        NSDictionary* materialJson;
        if(property[@"material"] ) {
            materialJson = property[@"material"];
        }
        
        
        if(materialJson) {
            for(id idx in node.geometry.materials) {
                SCNMaterial* material = (SCNMaterial* )idx;
                [RCTConvert setMaterialProperties:material properties:materialJson];
            }
        }
        
        for(id idx in modelNode.childNodes) {
            // iterate over all childnodes and apply shaders
            SCNNode* node = (SCNNode *)idx;
            if(materialJson) {
                for(id idx in node.geometry.materials) {
                    SCNMaterial* material = (SCNMaterial* )idx;
                    [RCTConvert setMaterialProperties:material properties:materialJson];
                }
            }
            
        }
        [node addChildNode:modelNode];
    });
    

}

@end
