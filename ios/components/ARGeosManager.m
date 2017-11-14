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

RCT_EXPORT_METHOD(addBox:(SCNBox *)geometry node:(SCNNode *)node frame:(NSString *)frame) {
    node.geometry = geometry;
    [[RCTARKitNodes sharedInstance] addNodeToScene:node inReferenceFrame:frame];
}

RCT_EXPORT_METHOD(addSphere:(SCNSphere *)geometry node:(SCNNode *)node frame:(NSString *)frame) {
    node.geometry = geometry;
    [[RCTARKitNodes sharedInstance] addNodeToScene:node inReferenceFrame:frame];
}

RCT_EXPORT_METHOD(addCylinder:(SCNCylinder *)geometry node:(SCNNode *)node frame:(NSString *)frame) {
    node.geometry = geometry;
    [[RCTARKitNodes sharedInstance] addNodeToScene:node inReferenceFrame:frame];
}

RCT_EXPORT_METHOD(addCone:(SCNCone *)geometry node:(SCNNode *)node frame:(NSString *)frame) {
    node.geometry = geometry;
    [[RCTARKitNodes sharedInstance] addNodeToScene:node inReferenceFrame:frame];
}

RCT_EXPORT_METHOD(addPyramid:(SCNPyramid *)geometry node:(SCNNode *)node frame:(NSString *)frame) {
    node.geometry = geometry;
    [[RCTARKitNodes sharedInstance] addNodeToScene:node inReferenceFrame:frame];
}

RCT_EXPORT_METHOD(addTube:(SCNTube *)geometry node:(SCNNode *)node frame:(NSString *)frame) {
    node.geometry = geometry;
    [[RCTARKitNodes sharedInstance] addNodeToScene:node inReferenceFrame:frame];
}

RCT_EXPORT_METHOD(addTorus:(SCNTorus *)geometry node:(SCNNode *)node frame:(NSString *)frame) {
    node.geometry = geometry;
    [[RCTARKitNodes sharedInstance] addNodeToScene:node inReferenceFrame:frame];
}

RCT_EXPORT_METHOD(addCapsule:(SCNCapsule *)geometry node:(SCNNode *)node frame:(NSString *)frame) {
    node.geometry = geometry;
    [[RCTARKitNodes sharedInstance] addNodeToScene:node inReferenceFrame:frame];
}

RCT_EXPORT_METHOD(addPlane:(SCNPlane *)geometry node:(SCNNode *)node frame:(NSString *)frame) {
    node.geometry = geometry;
    [[RCTARKitNodes sharedInstance] addNodeToScene:node inReferenceFrame:frame];
}

RCT_EXPORT_METHOD(addShape:(SCNShape *)geometry node:(SCNNode *)node frame:(NSString *)frame) {
    node.geometry = geometry;
    [[RCTARKitNodes sharedInstance] addNodeToScene:node inReferenceFrame:frame];
}

RCT_EXPORT_METHOD(addLight:(SCNLight *)light node:(SCNNode *)node frame:(NSString *)frame) {
    node.light = light;
    [[RCTARKitNodes sharedInstance] addNodeToScene:node inReferenceFrame:frame];
}


RCT_EXPORT_METHOD(unmount:(NSString *)identifier) {
 
    
    [[RCTARKitNodes sharedInstance] removeNodeForKey:identifier];

    
}

RCT_EXPORT_METHOD(updateNode:(NSString *)identifier properties:(NSDictionary *) properties) {

    [[RCTARKitNodes sharedInstance] updateNode:identifier properties:properties];

}

@end
