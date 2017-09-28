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
- (void)addText:(NSDictionary *)property material:(SCNMaterial *)material {
    
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
//    scnText.materials = @[face, face, border, border, border];
    scnText.materials = @[material, material, material, material, material];
    
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

@end
