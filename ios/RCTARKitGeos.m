//
//  RCTARKitGeos.m
//  RCTARKit
//
//  Created by Zehao Li on 9/24/17.
//  Copyright © 2017 HippoAR. All rights reserved.
//

#import "RCTARKitGeos.h"
#import "RCTConvert+ARKit.h"

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
    NSDictionary* shape = property[@"shape"];
    CGFloat width = [shape[@"width"] floatValue];
    CGFloat height = [shape[@"height"] floatValue];
    CGFloat length = [shape[@"length"] floatValue];
    CGFloat chamfer = [shape[@"chamfer"] floatValue];
    SCNBox *geometry = [SCNBox boxWithWidth:width height:height length:length chamferRadius:chamfer];
    
    SCNMaterial *material = [self materialFromProperty:property];
    geometry.materials = @[material, material, material, material, material, material];
    
    SCNNode *node = [SCNNode nodeWithGeometry:geometry];
    [self.nodeManager addNodeToScene:node property:property];
}

- (void)addSphere:(NSDictionary *)property {
    NSDictionary* shape = property[@"shape"];
    CGFloat radius = [shape[@"radius"] floatValue];
    SCNSphere *geometry = [SCNSphere sphereWithRadius:radius];
    
    SCNMaterial *material = [self materialFromProperty:property];
    geometry.materials = @[material];
    
    SCNNode *node = [SCNNode nodeWithGeometry:geometry];
    [self.nodeManager addNodeToScene:node property:property];
}

- (void)addCylinder:(NSDictionary *)property {
    NSDictionary* shape = property[@"shape"];
    CGFloat radius = [shape[@"radius"] floatValue];
    CGFloat height = [shape[@"height"] floatValue];
    SCNCylinder *geometry = [SCNCylinder cylinderWithRadius:radius height:height];
    
    SCNMaterial *material = [self materialFromProperty:property];
    geometry.materials = @[material, material, material];
    
    SCNNode *node = [SCNNode nodeWithGeometry:geometry];
    [self.nodeManager addNodeToScene:node property:property];
}

- (void)addCone:(NSDictionary *)property {
    NSDictionary* shape = property[@"shape"];
    CGFloat topR = [shape[@"topR"] floatValue];
    CGFloat bottomR = [shape[@"bottomR"] floatValue];
    CGFloat height = [shape[@"height"] floatValue];
    SCNCone *geometry = [SCNCone coneWithTopRadius:topR bottomRadius:bottomR height:height];
    
    SCNMaterial *material = [self materialFromProperty:property];
    geometry.materials = @[material, material];
    
    SCNNode *node = [SCNNode nodeWithGeometry:geometry];
    [self.nodeManager addNodeToScene:node property:property];
}

- (void)addPyramid:(NSDictionary *)property {
    NSDictionary* shape = property[@"shape"];
    CGFloat width = [shape[@"width"] floatValue];
    CGFloat length = [shape[@"length"] floatValue];
    CGFloat height = [shape[@"height"] floatValue];
    SCNPyramid *geometry = [SCNPyramid pyramidWithWidth:width height:height length:length];
    
    SCNMaterial *material = [self materialFromProperty:property];
    geometry.materials = @[material, material, material, material, material];
    
    SCNNode *node = [SCNNode nodeWithGeometry:geometry];
    [self.nodeManager addNodeToScene:node property:property];
}

- (void)addTube:(NSDictionary *)property {
    NSDictionary* shape = property[@"shape"];
    CGFloat innerR = [shape[@"innerR"] floatValue];
    CGFloat outerR = [shape[@"outerR"] floatValue];
    CGFloat height = [shape[@"height"] floatValue];
    SCNTube *geometry = [SCNTube tubeWithInnerRadius:innerR outerRadius:outerR height:height];
    
    SCNMaterial *material = [self materialFromProperty:property];
    geometry.materials = @[material, material, material, material];
    
    SCNNode *node = [SCNNode nodeWithGeometry:geometry];
    [self.nodeManager addNodeToScene:node property:property];
}

- (void)addTorus:(NSDictionary *)property {
    NSDictionary* shape = property[@"shape"];
    CGFloat ringR = [shape[@"ringR"] floatValue];
    CGFloat pipeR = [shape[@"pipeR"] floatValue];
    SCNTorus *geometry = [SCNTorus torusWithRingRadius:ringR pipeRadius:pipeR];
    
    SCNMaterial *material = [self materialFromProperty:property];
    geometry.materials = @[material];
    
    SCNNode *node = [SCNNode nodeWithGeometry:geometry];
    [self.nodeManager addNodeToScene:node property:property];
}

- (void)addCapsule:(NSDictionary *)property {
    NSDictionary* shape = property[@"shape"];
    CGFloat capR = [shape[@"capR"] floatValue];
    CGFloat height = [shape[@"height"] floatValue];
    SCNCapsule *geometry = [SCNCapsule capsuleWithCapRadius:capR height:height];
    
    SCNMaterial *material = [self materialFromProperty:property];
    geometry.materials = @[material];
    
    SCNNode *node = [SCNNode nodeWithGeometry:geometry];
    [self.nodeManager addNodeToScene:node property:property];
}

- (void)addPlane:(NSDictionary *)property {
    NSDictionary* shape = property[@"shape"];
    CGFloat width = [shape[@"width"] floatValue];
    CGFloat height = [shape[@"height"] floatValue];
    SCNPlane *geometry = [SCNPlane planeWithWidth:width height:height];
    
    SCNMaterial *material = [self materialFromProperty:property];
    material.doubleSided = YES;
    geometry.materials = @[material];
    
    SCNNode *node = [SCNNode nodeWithGeometry:geometry];
    [self.nodeManager addNodeToScene:node property:property];
}


- (void)addText:(NSDictionary *)property {
    
    // init SCNText
    NSString *text = [NSString stringWithFormat:@"%@", property[@"text"]];
    NSDictionary* font = property[@"font"];
    CGFloat depth = [font[@"depth"] floatValue];
    if (!text) {
        text = @"(null)";
    }
    if (!depth) {
        depth = 0.0f;
    }
    CGFloat fontSize = [font[@"size"] floatValue];
    CGFloat size = fontSize / 12;
    SCNText *scnText = [SCNText textWithString:text extrusionDepth:depth / size];
    scnText.flatness = 0.1;
    
    // font
    NSString *fontName = font[@"name"];
    if (fontName) {
        scnText.font = [UIFont fontWithName:fontName size:12];
    } else {
        scnText.font = [UIFont systemFontOfSize:12];
    }
    
    // chamfer
    CGFloat chamfer = [font[@"chamfer"] floatValue];
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
    NSDictionary* model = property[@"model"];
    CGFloat scale = [model[@"scale"] floatValue];
    
    NSString *path = [NSString stringWithFormat:@"%@", model[@"file"]];
    SCNNode *node = [self.arkitIO loadModel:path nodeName:model[@"node"] withAnimation:YES];
    
    node.scale = SCNVector3Make(scale, scale, scale);
    [self.nodeManager addNodeToScene:node property:property];
}

- (void)addImage:(NSDictionary *)property {}

- (SCNMaterial *)materialFromProperty:(NSDictionary *)property {
    return [RCTConvert SCNMaterial:property[@"material"]];
}

@end
