//
//  RCTARKitGeos.m
//  RCTARKit
//
//  Created by Zehao Li on 9/24/17.
//  Copyright © 2017 HippoAR. All rights reserved.
//

#import "RCTARKitGeos.h"

@implementation RCTARKitGeos

+ (instancetype)sharedInstance {
    static RCTARKitGeos *instance = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        if (instance == nil) {
            instance = [[self alloc] init];
        }
    });
    return instance;
}

- (instancetype)init {
    if ((self = [super init])) {
        self.arkitIO = [RCTARKitIO sharedInstance];
        self.nodeManager = [RCTARKitNodes sharedInstance];
    }
    return self;
}



#pragma mark - add a model or a geometry

- (void)addBox:(NSDictionary *)property {
    CGFloat width = [property[@"width"] floatValue];
    CGFloat height = [property[@"height"] floatValue];
    CGFloat length = [property[@"length"] floatValue];
    CGFloat chamfer = [property[@"chamfer"] floatValue];
    SCNBox *geometry = [SCNBox boxWithWidth:width height:height length:length chamferRadius:chamfer];
    
    SCNMaterial *material = [self materialFromProperty:property];
    geometry.materials = @[material, material, material, material, material, material];
    
    SCNNode *node = [SCNNode nodeWithGeometry:geometry];
    [self.nodeManager addNodeToScene:node property:property];
}

- (void)addSphere:(NSDictionary *)property {
    CGFloat radius = [property[@"radius"] floatValue];
    SCNSphere *geometry = [SCNSphere sphereWithRadius:radius];
    
    SCNMaterial *material = [self materialFromProperty:property];
    geometry.materials = @[material];
    
    SCNNode *node = [SCNNode nodeWithGeometry:geometry];
    [self.nodeManager addNodeToScene:node property:property];
}

- (void)addCylinder:(NSDictionary *)property {
    CGFloat radius = [property[@"radius"] floatValue];
    CGFloat height = [property[@"height"] floatValue];
    SCNCylinder *geometry = [SCNCylinder cylinderWithRadius:radius height:height];
    
    SCNMaterial *material = [self materialFromProperty:property];
    geometry.materials = @[material, material, material];
    
    SCNNode *node = [SCNNode nodeWithGeometry:geometry];
    [self.nodeManager addNodeToScene:node property:property];
}

- (void)addCone:(NSDictionary *)property {
    CGFloat topR = [property[@"topR"] floatValue];
    CGFloat bottomR = [property[@"bottomR"] floatValue];
    CGFloat height = [property[@"height"] floatValue];
    SCNCone *geometry = [SCNCone coneWithTopRadius:topR bottomRadius:bottomR height:height];
    
    SCNMaterial *material = [self materialFromProperty:property];
    geometry.materials = @[material, material];
    
    SCNNode *node = [SCNNode nodeWithGeometry:geometry];
    [self.nodeManager addNodeToScene:node property:property];
}

- (void)addPyramid:(NSDictionary *)property {
    CGFloat width = [property[@"width"] floatValue];
    CGFloat length = [property[@"length"] floatValue];
    CGFloat height = [property[@"height"] floatValue];
    SCNPyramid *geometry = [SCNPyramid pyramidWithWidth:width height:height length:length];
    
    SCNMaterial *material = [self materialFromProperty:property];
    geometry.materials = @[material, material, material, material, material];
    
    SCNNode *node = [SCNNode nodeWithGeometry:geometry];
    [self.nodeManager addNodeToScene:node property:property];
}

- (void)addTube:(NSDictionary *)property {
    CGFloat innerR = [property[@"innerR"] floatValue];
    CGFloat outerR = [property[@"outerR"] floatValue];
    CGFloat height = [property[@"height"] floatValue];
    SCNTube *geometry = [SCNTube tubeWithInnerRadius:innerR outerRadius:outerR height:height];
    
    SCNMaterial *material = [self materialFromProperty:property];
    geometry.materials = @[material, material, material, material];
    
    SCNNode *node = [SCNNode nodeWithGeometry:geometry];
    [self.nodeManager addNodeToScene:node property:property];
}

- (void)addTorus:(NSDictionary *)property {
    CGFloat ringR = [property[@"ringR"] floatValue];
    CGFloat pipeR = [property[@"pipeR"] floatValue];
    SCNTorus *geometry = [SCNTorus torusWithRingRadius:ringR pipeRadius:pipeR];
    
    SCNMaterial *material = [self materialFromProperty:property];
    geometry.materials = @[material];
    
    SCNNode *node = [SCNNode nodeWithGeometry:geometry];
    [self.nodeManager addNodeToScene:node property:property];
}

- (void)addCapsule:(NSDictionary *)property {
    CGFloat capR = [property[@"capR"] floatValue];
    CGFloat height = [property[@"height"] floatValue];
    SCNCapsule *geometry = [SCNCapsule capsuleWithCapRadius:capR height:height];
    
    SCNMaterial *material = [self materialFromProperty:property];
    geometry.materials = @[material];
    
    SCNNode *node = [SCNNode nodeWithGeometry:geometry];
    [self.nodeManager addNodeToScene:node property:property];
}

- (void)addPlane:(NSDictionary *)property {
    CGFloat width = [property[@"width"] floatValue];
    CGFloat height = [property[@"height"] floatValue];
    SCNPlane *geometry = [SCNPlane planeWithWidth:width height:height];
    
    SCNMaterial *material = [self materialFromProperty:property];
    geometry.materials = @[material];
    
    SCNNode *node = [SCNNode nodeWithGeometry:geometry];
    [self.nodeManager addNodeToScene:node property:property];
}

- (void)addText:(NSDictionary *)property {
    // init SCNText
    NSString *text = [NSString stringWithFormat:@"%@", property[@"text"]];
    CGFloat depth = [property[@"depth"] floatValue];
    if (!text) {
        text = @"(null)";
    }
    if (!depth) {
        depth = 0.0f;
    }
    CGFloat fontSize = [property[@"size"] floatValue];
    CGFloat size = fontSize / 12;
    SCNText *scnText = [SCNText textWithString:text extrusionDepth:depth / size];
    scnText.flatness = 0.1;
    
    // font
    NSString *font = property[@"name"];
    if (font) {
        scnText.font = [UIFont fontWithName:font size:12];
    } else {
        scnText.font = [UIFont systemFontOfSize:12];
    }
    
    // chamfer
    CGFloat chamfer = [property[@"chamfer"] floatValue];
    if (!chamfer) {
        chamfer = 0.0f;
    }
    scnText.chamferRadius = chamfer / size;
    
    // material
    SCNMaterial *face = [self materialFromProperty:property];
    SCNMaterial *border = [self materialFromProperty:property];
    scnText.materials = @[face, face, border, border, border];
    
    // init SCNNode
    SCNNode *textNode = [SCNNode nodeWithGeometry:scnText];
    
    // position textNode
    SCNVector3 min = SCNVector3Zero;
    SCNVector3 max = SCNVector3Zero;
    [textNode getBoundingBoxMin:&min max:&max];
    textNode.position = SCNVector3Make(-(min.x + max.x) / 2, -(min.y + max.y) / 2, -(min.z + max.z) / 2);
    
    SCNNode *textOrigin = [[SCNNode alloc] init];
    [textOrigin addChildNode:textNode];
    textOrigin.scale = SCNVector3Make(size, size, size);
    [self.nodeManager addNodeToScene:textOrigin property:property];
}

- (void)addModel:(NSDictionary *)property {
    CGFloat scale = [property[@"scale"] floatValue];
    
    NSString *path = [NSString stringWithFormat:@"%@", property[@"file"]];
    SCNNode *node = [self.arkitIO loadModel:path nodeName:property[@"node"] withAnimation:YES];
    
    node.scale = SCNVector3Make(scale, scale, scale);
    [self.nodeManager addNodeToScene:node property:property];
}

- (void)addImage:(NSDictionary *)property {}

- (SCNMaterial *)materialFromProperty:(NSDictionary *)property {
    SCNMaterial *material = [SCNMaterial new];
    
    if (property[@"color"]) {
        CGFloat r = [property[@"r"] floatValue];
        CGFloat g = [property[@"g"] floatValue];
        CGFloat b = [property[@"b"] floatValue];
        CGFloat a = [property[@"a"] floatValue];
        UIColor *color = [[UIColor alloc] initWithRed:r green:g blue:b alpha:a];
        material.diffuse.contents = color;
    } else {
        material.diffuse.contents = [UIColor whiteColor];
    }
    
    if (property[@"metalness"]) {
        material.lightingModelName = SCNLightingModelPhysicallyBased;
        material.metalness.contents = @([property[@"metalness"] floatValue]);
    }
    if (property[@"roughness"]) {
        material.lightingModelName = SCNLightingModelPhysicallyBased;
        material.roughness.contents = @([property[@"roughness"] floatValue]);
    }
    
    return material;
}

@end
