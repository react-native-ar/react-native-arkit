//
//  Plane.m
//  RCTARKit
//
//  Created by Zehao Li on 7/10/17.
//  Copyright © 2017 Facebook. All rights reserved.
//

#import "Plane.h"

@implementation Plane

- (instancetype)initWithAnchor:(ARPlaneAnchor *)anchor isHidden:(BOOL)hidden {
    self = [super init];

    self.anchor = anchor;
    float width = anchor.extent.x;
    float length = anchor.extent.z;

    float planeHeight = 0.01;

    self.planeGeometry = [SCNBox boxWithWidth:width height:planeHeight length:length chamferRadius:0];

    SCNMaterial *material = [SCNMaterial new];
    UIImage *img = [UIImage imageNamed:@"tron_grid.png"];

    material.diffuse.contents = img;

    SCNMaterial *transparentMaterial = [SCNMaterial new];
    transparentMaterial.diffuse.contents = [UIColor colorWithWhite:1.0 alpha:0.0];

    if (hidden) {
        self.planeGeometry.materials = @[transparentMaterial, transparentMaterial, transparentMaterial, transparentMaterial, transparentMaterial, transparentMaterial];
    } else {
        self.planeGeometry.materials = @[transparentMaterial, transparentMaterial, transparentMaterial, transparentMaterial, material, transparentMaterial];
    }

    SCNNode *planeNode = [SCNNode nodeWithGeometry:self.planeGeometry];

    planeNode.position = SCNVector3Make(0, -planeHeight / 2, 0);

    planeNode.physicsBody = [SCNPhysicsBody
                             bodyWithType:SCNPhysicsBodyTypeKinematic
                             shape: [SCNPhysicsShape shapeWithGeometry:self.planeGeometry options:nil]];

    [self setTextureScale];
    [self addChildNode:planeNode];
    return self;
}

- (void)update:(ARPlaneAnchor *)anchor {
    self.planeGeometry.width = anchor.extent.x;
    self.planeGeometry.length = anchor.extent.z;

    self.position = SCNVector3Make(anchor.center.x, 0, anchor.center.z);

    SCNNode *node = [self.childNodes firstObject];
    //self.physicsBody = nil;
    node.physicsBody = [SCNPhysicsBody
                        bodyWithType:SCNPhysicsBodyTypeKinematic
                        shape: [SCNPhysicsShape shapeWithGeometry:self.planeGeometry options:nil]];
    [self setTextureScale];
}

- (void)setTextureScale {
    CGFloat width = self.planeGeometry.width;
    CGFloat height = self.planeGeometry.length;

    SCNMaterial *material = self.planeGeometry.materials[4];
    material.diffuse.contentsTransform = SCNMatrix4MakeScale(width, height, 1);
    material.diffuse.wrapS = SCNWrapModeRepeat;
    material.diffuse.wrapT = SCNWrapModeRepeat;
}

- (void)hide {
    SCNMaterial *transparentMaterial = [SCNMaterial new];
    transparentMaterial.diffuse.contents = [UIColor colorWithWhite:1.0 alpha:0.0];
    self.planeGeometry.materials = @[transparentMaterial, transparentMaterial, transparentMaterial, transparentMaterial, transparentMaterial, transparentMaterial];
}

@end
