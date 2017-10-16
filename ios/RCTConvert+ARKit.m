//
//  RCTConvert+ARKit.m
//  RCTARKit
//
//  Created by Zehao Li on 9/28/17.
//  Copyright © 2017 HippoAR. All rights reserved.
//

#import "RCTConvert+ARKit.h"
#import "SVGBezierPath.h"

@implementation RCTConvert (ARKit)

+ (SCNMaterial *)SCNMaterial:(id)json {
    SCNMaterial *material = [SCNMaterial new];
    [self setMaterialProperties:material properties:json];
    
    return material;
}



+ (SCNVector3)SCNVector3:(id)json {
    CGFloat x = [json[@"x"] floatValue];
    CGFloat y = [json[@"y"] floatValue];
    CGFloat z = [json[@"z"] floatValue];
    return SCNVector3Make(x, y, z);
}

+ (SCNVector4)SCNVector4:(id)json {
    CGFloat x = [json[@"x"] floatValue];
    CGFloat y = [json[@"y"] floatValue];
    CGFloat z = [json[@"z"] floatValue];
    CGFloat w = [json[@"w"] floatValue];
    return SCNVector4Make(x, y, z, w);
}


+ (SCNNode *)SCNNode:(id)json {
    SCNNode *node = [SCNNode new];
        
    node.name = [NSString stringWithFormat:@"%@", json[@"id"]];
    [self setNodeProperties:node properties:json];

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
    if(shape[@"cornerRadius"]) {
        geometry.cornerRadius = [shape[@"cornerRadius"] floatValue];
    }
    if(shape[@"cornerSegmentCount"]) {
        geometry.cornerSegmentCount = [shape[@"cornerSegmentCount"] intValue];
    }
    if(shape[@"widthSegmentCount"]) {
        geometry.widthSegmentCount = [shape[@"widthSegmentCount"] intValue];
    }
    if(shape[@"heightSegmentCount"]) {
        geometry.heightSegmentCount = [shape[@"heightSegmentCount"] intValue];
    }
    SCNMaterial *material = [self SCNMaterial:json[@"material"]];
    material.doubleSided = YES;
    geometry.materials = @[material];
    return geometry;
}

+ (SCNShape * )SCNShape:(id)json {
    NSDictionary* shape = json[@"shape"];
    NSString * pathString =shape[@"path"];

    id path = [SVGBezierPath pathsFromSVGString:pathString];

    CGFloat extrusion = [shape[@"extrusion"] floatValue];
    SCNPlane *geometry = [SCNShape shapeWithPath:path extrusionDepth:extrusion];
  
    SCNMaterial *material = [self SCNMaterial:json[@"material"]];
   
    geometry.materials = @[material];
    return geometry;
}


+ (SCNTextNode *)SCNTextNode:(id)json {
    // init SCNText
    NSString *text = [NSString stringWithFormat:@"%@", json[@"text"]];
    if (!text) {
        text = @"(null)";
    }
    
    NSDictionary* font = json[@"font"];
    CGFloat depth = [font[@"depth"] floatValue];
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
    SCNMaterial *material = [self SCNMaterial:json[@"material"]];
    scnText.materials = @[material, material, material, material, material];
    
    
    // SCNTextNode
    SCNTextNode *textNode = [SCNNode nodeWithGeometry:scnText];
    textNode.scale = SCNVector3Make(size, size, size);
    
    // position textNode
    SCNVector3 min = SCNVector3Zero;
    SCNVector3 max = SCNVector3Zero;
    [textNode getBoundingBoxMin:&min max:&max];

    textNode.position = SCNVector3Make(-(min.x + max.x) / 2 * size,
                                       -(min.y + max.y) / 2 * size,
                                       -(min.z + max.z) / 2 * size);
    
    return textNode;
}


+ (void)setMaterialProperties:(SCNMaterial *)material properties:(id)json {
    if (json[@"blendMode"]) {
        material.blendMode = (SCNBlendMode) [json[@"blendMode"] integerValue];
    }
    if (json[@"lightingModel"]) {
        material.lightingModelName = json[@"lightingModel"];
    }
    if (json[@"diffuse"]) {
        material.diffuse.contents = [self UIColor:json[@"diffuse"]];
    }
    
    if (json[@"metalness"]) {
        material.lightingModelName = SCNLightingModelPhysicallyBased;
        material.metalness.contents = @([json[@"metalness"] floatValue]);
    }
    if (json[@"roughness"]) {
        material.lightingModelName = SCNLightingModelPhysicallyBased;
        material.roughness.contents = @([json[@"roughness"] floatValue]);
    }
    
    if(json[@"shaders"] ) {
        material.shaderModifiers = json[@"shaders"];
    }
}

+ (void)setNodeProperties:(SCNNode *)node properties:(id)json {
    if(json[@"transition"]) {
        NSDictionary * transition =json[@"transition"];
        if(transition[@"duration"]) {
            [SCNTransaction setAnimationDuration:[transition[@"duration"] floatValue]];
        } else {
            [SCNTransaction setAnimationDuration:0.0];
        }
      
    } else {
        [SCNTransaction setAnimationDuration:0.0];
    }
    if (json[@"position"]) {
        node.position = [self SCNVector3:json[@"position"]];
    }
    
    if (json[@"eulerAngles"]) {
        node.eulerAngles = [self SCNVector3:json[@"eulerAngles"]];
    }
    
    if (json[@"orientation"]) {
        node.orientation = [self SCNVector4:json[@"orientation"]];
    }
    
    if (json[@"rotation"]) {
        node.rotation = [self SCNVector4:json[@"rotation"]];
    }
}



@end
