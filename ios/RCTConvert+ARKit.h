//
//  RCTConvert+ARKit.h
//  RCTARKit
//
//  Created by Zehao Li on 9/28/17.
//  Copyright © 2017 HippoAR. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <SceneKit/SceneKit.h>
#import <React/RCTConvert.h>

@interface SCNTextNode : SCNNode
@end


@interface RCTConvert (ARKit)

+ (SCNMaterial *)SCNMaterial:(id)json;

+ (SCNVector3)SCNVector3:(id)json;
+ (SCNVector4)SCNVector4:(id)json;
+ (SCNNode *)SCNNode:(id)json;

+ (SCNBox *)SCNBox:(id)json;
+ (SCNSphere *)SCNSphere:(id)json;
+ (SCNCylinder *)SCNCylinder:(id)json;
+ (SCNCone *)SCNCone:(id)json;
+ (SCNPyramid *)SCNPyramid:(id)json;
+ (SCNTube *)SCNTube:(id)json;
+ (SCNTorus *)SCNTorus:(id)json;
+ (SCNCapsule *)SCNCapsule:(id)json;
+ (SCNPlane *)SCNPlane:(id)json;

+ (SCNTextNode *)SCNTextNode:(id)json;

+ (SCNLight *)SCNLight:(id)json;

+ (void)setNodeProperties:(SCNNode *)node properties:(id)json;
+ (void)setMaterialProperties:(SCNMaterial *)material properties:(id)json;

@end

