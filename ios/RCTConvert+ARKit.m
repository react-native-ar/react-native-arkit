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


+ (void)addMaterials:(SCNGeometry *)geometry json:(id)json sides:(int) sides {
    SCNMaterial *material = [self SCNMaterial:json[@"material"]];
    
    NSMutableArray *materials = [NSMutableArray array];
    for (int i = 0; i < sides; i++)
        [materials addObject: material];
    geometry.materials = materials;
}

+ (SCNBox *)SCNBox:(id)json {
    NSDictionary *shape = json[@"shape"];
    
    
    CGFloat width = [shape[@"width"] floatValue];
    CGFloat height = [shape[@"height"] floatValue];
    CGFloat length = [shape[@"length"] floatValue];
    CGFloat chamfer = [shape[@"chamfer"] floatValue];
    SCNBox *geometry = [SCNBox boxWithWidth:width height:height length:length chamferRadius:chamfer];
    
    [self addMaterials:geometry json:json sides:6];
    
    return geometry;
}


+ (SCNSphere *)SCNSphere:(id)json {
    NSDictionary* shape = json[@"shape"];
    CGFloat radius = [shape[@"radius"] floatValue];
    SCNSphere *geometry = [SCNSphere sphereWithRadius:radius];
    
    [self addMaterials:geometry json:json sides:1];
    
    return geometry;
}

+ (SCNCylinder *)SCNCylinder:(id)json {
    NSDictionary* shape = json[@"shape"];
    CGFloat radius = [shape[@"radius"] floatValue];
    CGFloat height = [shape[@"height"] floatValue];
    SCNCylinder *geometry = [SCNCylinder cylinderWithRadius:radius height:height];
    
    [self addMaterials:geometry json:json sides:3];
    
    return geometry;
}

+ (SCNCone *)SCNCone:(id)json {
    NSDictionary* shape = json[@"shape"];
    CGFloat topR = [shape[@"topR"] floatValue];
    CGFloat bottomR = [shape[@"bottomR"] floatValue];
    CGFloat height = [shape[@"height"] floatValue];
    SCNCone *geometry = [SCNCone coneWithTopRadius:topR bottomRadius:bottomR height:height];
    
    [self addMaterials:geometry json:json sides:2];
    
    return geometry;
}

+ (SCNPyramid *)SCNPyramid:(id)json {
    NSDictionary* shape = json[@"shape"];
    CGFloat width = [shape[@"width"] floatValue];
    CGFloat length = [shape[@"length"] floatValue];
    CGFloat height = [shape[@"height"] floatValue];
    SCNPyramid *geometry = [SCNPyramid pyramidWithWidth:width height:height length:length];
    
    [self addMaterials:geometry json:json sides:5];
    
    return geometry;
}

+ (SCNTube *)SCNTube:(id)json {
    NSDictionary* shape = json[@"shape"];
    CGFloat innerR = [shape[@"innerR"] floatValue];
    CGFloat outerR = [shape[@"outerR"] floatValue];
    CGFloat height = [shape[@"height"] floatValue];
    SCNTube *geometry = [SCNTube tubeWithInnerRadius:innerR outerRadius:outerR height:height];
    
    [self addMaterials:geometry json:json sides:4];
    
    return geometry;
}

+ (SCNTorus *)SCNTorus:(id)json {
    NSDictionary* shape = json[@"shape"];
    CGFloat ringR = [shape[@"ringR"] floatValue];
    CGFloat pipeR = [shape[@"pipeR"] floatValue];
    SCNTorus *geometry = [SCNTorus torusWithRingRadius:ringR pipeRadius:pipeR];
    
    [self addMaterials:geometry json:json sides:1];
    
    return geometry;
}

+ (SCNCapsule *)SCNCapsule:(id)json {
    NSDictionary* shape = json[@"shape"];
    CGFloat capR = [shape[@"capR"] floatValue];
    CGFloat height = [shape[@"height"] floatValue];
    SCNCapsule *geometry = [SCNCapsule capsuleWithCapRadius:capR height:height];
    
    [self addMaterials:geometry json:json sides:1];
    
    return geometry;
}

+ (SCNImageNode *)SCNImageNode:(id)json {
    SCNPlane *planeGeometry = [SCNPlane planeWithWidth:0.5 height:0.5];
    NSDictionary* shape = json[@"shape"];

    UIImage *image = [UIImage imageWithContentsOfFile:@"https://arworldimages.s3.us-east-2.amazonaws.com/%2F00c3e640-9232-11ea-8c4f-59f384dfd412.png"];
    material.diffuse.contents = image;

    NSMutableArray *materials = [NSMutableArray array];
    [materials addObject:@(material)];


    planeGeometry.materials = materials;

    SCNImageNode *paintingNode= [SCNNode nodeWithGeometry:planeGeometry];
    SCNMatrix4 transform = SCNMatrix4Identity;
    SCNVector3 angles = SCNVector3Make(0, 0, 0);
    SCNVector3 position = SCNVector3Make(0, 0, -3);


    paintingNode.transform = transform;
    paintingNode.eulerAngles = angles;
    paintingNode.position = position;

    return paintingNode;
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
    [self addMaterials:geometry json:json sides:1];
    
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

+ (void)setChamferProfilePathSvg:(SCNShape *)geometry properties:(NSDictionary *)shape {
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
        [self setChamferProfilePathSvg:geometry properties:shape];
    }
    
    [self addMaterials:geometry json:json sides:1];
    
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
    [self addMaterials:scnText json:json sides:5];
    
    
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


+ (void)setMaterialPropertyContents:(id)property material:(SCNMaterialProperty *)material {
    
    if (property[@"path"]) {
        SCNMatrix4 m = SCNMatrix4Identity;
        
        // scenekit has an issue with indexed-colour png's on some devices, so we redraw the image. See for more details: https://stackoverflow.com/questions/40058359/scenekit-some-textures-have-a-red-hue/45824190#45824190
        
        UIImage *correctedImage;
        UIImage *inputImage = [UIImage imageNamed:property[@"path"]];
        CGFloat width  = inputImage.size.width;
        CGFloat height = inputImage.size.height;
        
        UIGraphicsBeginImageContext(inputImage.size);
        [inputImage drawInRect:(CGRectMake(0, 0, width, height))];
        correctedImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        material.contents = correctedImage;

        
        if (property[@"wrapS"]) {
            material.wrapS = (SCNWrapMode) [property[@"wrapS"] integerValue];
        }
        
        if (property[@"wrapT"]) {
            material.wrapT = (SCNWrapMode) [property[@"wrapT"] integerValue];
        }
        
        if (property[@"wrap"]) {
            material.wrapT = (SCNWrapMode) [property[@"wrapT"] integerValue];
            material.wrapS = (SCNWrapMode) [property[@"wrapS"] integerValue];
        }
        
        if (property[@"scale"]) {
            float x = [property[@"scale"][@"x"] floatValue];
            float y = [property[@"scale"][@"y"] floatValue];
            float z = [property[@"scale"][@"z"] floatValue];
            
            m = SCNMatrix4Mult(m, SCNMatrix4MakeScale(x, y, z));
        }
        
        if (property[@"rotation"]) {
            float a = [property[@"rotation"][@"angle"] floatValue];
            float x = [property[@"rotation"][@"x"] floatValue];
            float y = [property[@"rotation"][@"y"] floatValue];
            float z = [property[@"rotation"][@"z"] floatValue];
            
            m = SCNMatrix4Mult(m, SCNMatrix4MakeRotation(a, x, y, z));
        }
        
        if (property[@"translation"]) {
            float x = [property[@"translation"][@"x"] floatValue];
            float y = [property[@"translation"][@"y"] floatValue];
            float z = [property[@"translation"][@"z"] floatValue];
            
            m = SCNMatrix4Mult(m, SCNMatrix4MakeTranslation(x, y, z));
        }
        
        material.contentsTransform = m;
        
        
    } else if (property[@"color"]) {
        material.contents = [self UIColor:property[@"color"]];
    }
    if (property[@"intensity"]) {
        material.intensity = [property[@"intensity"] floatValue];
    }
}

+ (void)setMaterialProperties:(SCNMaterial *)material properties:(id)json {
    if (json[@"doubleSided"]) {
        material.doubleSided = [json[@"doubleSided"] boolValue];
    } else {
        material.doubleSided = YES;
    }
    
    if (json[@"blendMode"]) {
        material.blendMode = (SCNBlendMode) [json[@"blendMode"] integerValue];
    }
    
    if (json[@"transparencyMode"]) {
        material.transparencyMode = (SCNTransparencyMode) [json[@"transparencyMode"] integerValue];
    }

    if (json[@"lightingModel"]) {
        material.lightingModelName = json[@"lightingModel"];
    }
    
    if (json[@"diffuse"]) {
        [self setMaterialPropertyContents:json[@"diffuse"] material:material.diffuse];
    }
    
    if (json[@"normal"]) {
        [self setMaterialPropertyContents:json[@"normal"] material:material.normal];
    }
    
    if (json[@"displacement"]) {
        [self setMaterialPropertyContents:json[@"displacement"] material:material.displacement];
    }
    
    if (json[@"specular"]) {
        [self setMaterialPropertyContents:json[@"specular"] material:material.specular];
    }
    
    if (json[@"transparency"]) {
        material.transparency = [json[@"transparency"] floatValue];
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
    
    if(json[@"writesToDepthBuffer"] ) {
        material.writesToDepthBuffer = [json[@"writesToDepthBuffer"] boolValue];
    }
    
    if(json[@"colorBufferWriteMask"] ) {
        material.colorBufferWriteMask = [json[@"colorBufferWriteMask"] integerValue];
    }
    
    if(json[@"fillMode"] ) {
        material.fillMode = [json[@"fillMode"] integerValue];
    }
    
    if(json[@"doubleSided"]) {
        material.doubleSided = [json[@"doubleSided"] boolValue];
    }
    
    if(json[@"litPerPixel"]) {
        material.litPerPixel = [json[@"litPerPixel"] boolValue];
    }
}

+ (void)setNodeProperties:(SCNNode *)node properties:(id)json {
    
    if (json[@"categoryBitMask"]) {
        node.categoryBitMask = [json[@"categoryBitMask"] integerValue];
    }
    if (json[@"renderingOrder"]) {
        node.renderingOrder = [json[@"renderingOrder"] integerValue];
    }
    if (json[@"castsShadow"]) {
        node.castsShadow = [json[@"castsShadow"] boolValue];
    }
    if (json[@"constraint"]) {
        SCNBillboardConstraint *constraint = [SCNBillboardConstraint billboardConstraint];
        constraint.freeAxes = [json[@"constraint"] integerValue];
        node.constraints = @[constraint];
    }
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
    
    if (json[@"opacity"]) {
        node.opacity = [json[@"opacity"] floatValue];
    }
}


+ (NSSet *) specialShapeProperties {
    return [[NSSet alloc] initWithArray:
            @[@"pathSvg", @"chamferProfilePathSvg"]];
}


+ (void)setShapeProperties:(SCNGeometry *)geometry properties:(id)shapeJson {
    
    // most properties are strings
    for (NSString* key in shapeJson) {
        if(![self.specialShapeProperties containsObject:key]) {
            id value = [NSNumber numberWithFloat:[shapeJson[key] floatValue]];
            [geometry setValue:value forKey:key];
        }
    }
    
    if([geometry isKindOfClass:[SCNShape class]]) {
        SCNShape * shapeGeometry = (SCNShape * ) geometry;
        if(shapeJson[@"pathSvg"]) {
            NSString * pathString = shapeJson[@"pathSvg"];
            SVGBezierPath * path = [self svgStringToBezier:pathString];
            if (shapeJson[@"pathFlatness"]) {
                path.flatness = [shapeJson[@"pathFlatness"] floatValue];
            }
            shapeGeometry.path = path;
        }
        if (shapeJson[@"chamferProfilePathSvg"]) {
            [self setChamferProfilePathSvg: shapeGeometry properties:shapeJson];
        }
        
    }
}



+ (void)setLightProperties:(SCNLight *)light properties:(id)json {
    if (json[@"lightCategoryBitMask"]) {
        light.categoryBitMask = [json[@"lightCategoryBitMask"] integerValue];
    }
    if(json[@"type"]) {
        light.type = json[@"type"];
    }
    if(json[@"color"]) {
        light.color = (__bridge id _Nonnull)([RCTConvert CGColor:json[@"color"]]);
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
        light.shadowColor = (__bridge id _Nonnull)([RCTConvert CGColor:json[@"shadowColor"]]);
    }
    
    
    if(json[@"shadowSampleCount"]) {
        light.shadowSampleCount = [json[@"shadowSampleCount"] integerValue];
    }
    
    if(json[@"shadowBias"]) {
        light.shadowBias = [json[@"shadowBias"] floatValue];
    }
    
    if(json[@"shadowMode"]) {
        light.shadowMode = [json[@"shadowMode"] integerValue];
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

+ (ARPlaneDetection)ARPlaneDetection:(id)number {
    return (ARPlaneDetection)  [number integerValue];
}



@end
