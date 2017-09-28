//
//  RCTConvert+ARKit.m
//  RCTARKit
//
//  Created by Zehao Li on 9/28/17.
//  Copyright © 2017 HippoAR. All rights reserved.
//

#import "RCTConvert+ARKit.h"

@implementation RCTConvert (ARKit)

+ (SCNMaterial *)SCNMaterial:(id)json {
    SCNMaterial *material = [SCNMaterial new];
    if (json[@"diffuse"]) {
        material.diffuse.contents = [self UIColor:json[@"diffuse"]];
    } else {
        material.diffuse.contents = [UIColor blackColor];
    }
    
    if (json[@"metalness"]) {
        material.lightingModelName = SCNLightingModelPhysicallyBased;
        material.metalness.contents = @([json[@"metalness"] floatValue]);
    }
    if (json[@"roughness"]) {
        material.lightingModelName = SCNLightingModelPhysicallyBased;
        material.roughness.contents = @([json[@"roughness"] floatValue]);
    }
    
    return material;
}

+ (SCNVector3)SCNVector3:(id)json {
    CGFloat x = [json[@"x"] floatValue];
    CGFloat y = [json[@"y"] floatValue];
    CGFloat z = [json[@"z"] floatValue];
    return SCNVector3Make(x, y, z);
}

+ (SCNNode *)SCNNode:(id)json {
    SCNNode *node = [SCNNode new];
    
    node.name = [NSString stringWithFormat:@"%@", json[@"id"]];
    node.position = [self SCNVector3:json[@"position"]];

    return node;
}

+ (SCNBox *)SCNBox:(id)json {
    NSDictionary *shape = json[@"shape"];
    CGFloat width = [shape[@"width"] floatValue];
    CGFloat height = [shape[@"height"] floatValue];
    CGFloat length = [shape[@"length"] floatValue];
    CGFloat chamfer = [shape[@"chamfer"] floatValue];
    SCNBox *geometry = [SCNBox boxWithWidth:width height:height length:length chamferRadius:chamfer];
    
    SCNMaterial *material = [self SCNMaterial:json[@"material"]];
    geometry.materials = @[material, material, material, material, material, material];

    return geometry;
}

+ (SCNSphere *)SCNSphere:(id)json {
    NSDictionary* shape = json[@"shape"];
    CGFloat radius = [shape[@"radius"] floatValue];
    SCNSphere *geometry = [SCNSphere sphereWithRadius:radius];
    
    SCNMaterial *material = [self SCNMaterial:json[@"material"]];
    geometry.materials = @[material];

    return geometry;
}

+ (SCNCylinder *)SCNCylinder:(id)json {
    NSDictionary* shape = json[@"shape"];
    CGFloat radius = [shape[@"radius"] floatValue];
    CGFloat height = [shape[@"height"] floatValue];
    SCNCylinder *geometry = [SCNCylinder cylinderWithRadius:radius height:height];
    
    SCNMaterial *material = [self SCNMaterial:json[@"material"]];
    geometry.materials = @[material, material, material];
    
    return geometry;
}

+ (SCNCone *)SCNCone:(id)json {
    NSDictionary* shape = json[@"shape"];
    CGFloat topR = [shape[@"topR"] floatValue];
    CGFloat bottomR = [shape[@"bottomR"] floatValue];
    CGFloat height = [shape[@"height"] floatValue];
    SCNCone *geometry = [SCNCone coneWithTopRadius:topR bottomRadius:bottomR height:height];
    
    SCNMaterial *material = [self SCNMaterial:json[@"material"]];
    geometry.materials = @[material, material];
    
    return geometry;
}

+ (SCNPyramid *)SCNPyramid:(id)json {
    NSDictionary* shape = json[@"shape"];
    CGFloat width = [shape[@"width"] floatValue];
    CGFloat length = [shape[@"length"] floatValue];
    CGFloat height = [shape[@"height"] floatValue];
    SCNPyramid *geometry = [SCNPyramid pyramidWithWidth:width height:height length:length];
    
    SCNMaterial *material = [self SCNMaterial:json[@"material"]];
    geometry.materials = @[material, material, material, material, material];
    
    return geometry;
}

+ (SCNTube *)SCNTube:(id)json {
    NSDictionary* shape = json[@"shape"];
    CGFloat innerR = [shape[@"innerR"] floatValue];
    CGFloat outerR = [shape[@"outerR"] floatValue];
    CGFloat height = [shape[@"height"] floatValue];
    SCNTube *geometry = [SCNTube tubeWithInnerRadius:innerR outerRadius:outerR height:height];
    
    SCNMaterial *material = [self SCNMaterial:json[@"material"]];
    geometry.materials = @[material, material, material, material];
    
    return geometry;
}

+ (SCNTorus *)SCNTorus:(id)json {
    NSDictionary* shape = json[@"shape"];
    CGFloat ringR = [shape[@"ringR"] floatValue];
    CGFloat pipeR = [shape[@"pipeR"] floatValue];
    SCNTorus *geometry = [SCNTorus torusWithRingRadius:ringR pipeRadius:pipeR];
    
    SCNMaterial *material = [self SCNMaterial:json[@"material"]];
    geometry.materials = @[material];
    
    return geometry;
}
    
+ (SCNCapsule *)SCNCapsule:(id)json {
    NSDictionary* shape = json[@"shape"];
    CGFloat capR = [shape[@"capR"] floatValue];
    CGFloat height = [shape[@"height"] floatValue];
    SCNCapsule *geometry = [SCNCapsule capsuleWithCapRadius:capR height:height];
    
    SCNMaterial *material = [self SCNMaterial:json[@"material"]];
    geometry.materials = @[material];
    
    return geometry;
}

+ (SCNPlane *)SCNPlane:(id)json {
    NSDictionary* shape = json[@"shape"];
    CGFloat width = [shape[@"width"] floatValue];
    CGFloat height = [shape[@"height"] floatValue];
    SCNPlane *geometry = [SCNPlane planeWithWidth:width height:height];
    
    SCNMaterial *material = [self SCNMaterial:json[@"material"]];
    material.doubleSided = YES;
    geometry.materials = @[material];
    
    return geometry;
}

@end
