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

+ (SVGBezierPath *)svgStringToBezier:(NSString *)pathString {
    NSArray * paths = [SVGBezierPath pathsFromSVGString:pathString];
    SVGBezierPath * fullPath;
    for(SVGBezierPath *path in paths) {
        if(!fullPath) {
            fullPath = path;
        } else {
            [fullPath appendPath:path];
        }
    }
    return fullPath;
}

+ (SCNShape * )SCNShape:(id)json {
    NSDictionary* shape = json[@"shape"];
    NSString * pathString = shape[@"pathSvg"];
    
    SVGBezierPath * path = [self svgStringToBezier:pathString];
    
    if (shape[@"pathFlatness"]) {
        path.flatness = [shape[@"pathFlatness"] floatValue];
    }
    CGFloat extrusion = [shape[@"extrusion"] floatValue];
    SCNShape *geometry = [SCNShape shapeWithPath:path extrusionDepth:extrusion];
    if (shape[@"chamferMode"]) {
        geometry.chamferMode = (SCNChamferMode) [shape[@"chamferMode"] integerValue];
    }
    if (shape[@"chamferRadius"]) {
        geometry.chamferRadius = [shape[@"chamferRadius"] floatValue];
    }
    
    if (shape[@"chamferProfilePathSvg"]) {
        
        SVGBezierPath * path = [self svgStringToBezier:shape[@"chamferProfilePathSvg"]];
        if(shape[@"chamferProfilePathFlatness"]) {
            path.flatness = [shape[@"chamferProfilePathFlatness"] floatValue];
        }
        // normalize path
        CGRect boundingBox = path.bounds;
        if(path.bounds.size.width !=0 && path.bounds.size.height != 0) {
            CGFloat scaleX = 1/boundingBox.size.width;
            CGFloat scaleY =  scaleY = 1/boundingBox.size.height;
            
            CGAffineTransform transform = CGAffineTransformMakeScale(scaleX, scaleY);
            [path applyTransform:transform];
            geometry.chamferProfile = path;
        } else {
            NSLog(@"Invalid chamferProfilePathFlatness");
        }
       
    }
    
    
    
    SCNMaterial *material = [self SCNMaterial:json[@"material"]];
    material.doubleSided = YES;
    
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
    textNode.name = [NSString stringWithFormat:@"%@", json[@"id"]];

    
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


+ (SCNLight *)SCNLight:(id)json {
    SCNLight * light = [SCNLight light];
    [self setLightProperties:light properties:json];
    return light;
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
    
    if (json[@"scale"]) {
        CGFloat scale = [json[@"scale"] floatValue];
        node.scale = SCNVector3Make(scale, scale, scale);
        
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


+ (void)setLightProperties:(SCNLight *)light properties:(id)json {
    if(json[@"type"]) {
        light.type = json[@"type"];
    }
    if(json[@"color"]) {
        light.color = json[@"color"];
    }
    if(json[@"temperature"]) {
        light.temperature = [json[@"temperature"] floatValue];
    }
    
    if(json[@"intensity"]) {
        light.intensity = [json[@"intensity"] floatValue];
    }
    
    if(json[@"attenuationStartDistance"]) {
        light.attenuationStartDistance = [json[@"attenuationStartDistance"] floatValue];
    }
    
    if(json[@"attenuationEndDistance"]) {
        light.attenuationEndDistance = [json[@"attenuationEndDistance"] floatValue];
    }
    
    if(json[@"spotInnerAngle"]) {
        light.spotInnerAngle = [json[@"spotInnerAngle"] floatValue];
    }
    
    if(json[@"spotOuterAngle"]) {
        light.spotOuterAngle = [json[@"spotOuterAngle"] floatValue];
    }
    
    if(json[@"castsShadow"]) {
        light.castsShadow = [json[@"castsShadow"] boolValue];
    }
    
    if(json[@"shadowRadius"]) {
        light.shadowRadius = [json[@"shadowRadius"] floatValue];
    }
    
    if(json[@"shadowColor"]) {
        light.shadowColor = json[@"shadowColor"];
    }
    
    
    if(json[@"shadowSampleCount"]) {
        light.shadowSampleCount = [json[@"shadowSampleCount"] integerValue];
    }
    
    if(json[@"shadowBias"]) {
        light.shadowBias = [json[@"shadowBias"] floatValue];
    }
    
    if(json[@"orthographicScale"]) {
        light.orthographicScale = [json[@"orthographicScale"] floatValue];
    }
    
    if(json[@"zFar"]) {
        light.zFar = [json[@"zFar"] floatValue];
    }
    
    if(json[@"zNear"]) {
        light.zNear = [json[@"zNear"] floatValue];
    }
}


@end
