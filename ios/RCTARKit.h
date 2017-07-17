//
//  RCTARKit.h
//  RCTARKit
//
//  Created by HippoAR on 7/9/17.
//  Copyright © 2017 HippoAR. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SceneKit/SceneKit.h>
#import <ARKit/ARKit.h>

#import <React/RCTComponent.h>

typedef struct {
    float x;
    float y;
    float z;
    float width;
    float height;
    float length;
    float chamfer;
} BoxProperty;

typedef struct {
    float x;
    float y;
    float z;
    float radius;
} SphereProperty;

typedef struct {
    float x;
    float y;
    float z;
    float radius;
    float height;
} CylinderProperty;

typedef struct {
    float x;
    float y;
    float z;
    float topR;
    float bottomR;
    float height;
} ConeProperty;

typedef struct {
    float x;
    float y;
    float z;
    float width;
    float height;
    float length;
} PyramidProperty;

typedef struct {
    float x;
    float y;
    float z;
    float innerR;
    float outerR;
    float height;
} TubeProperty;

typedef struct {
    float x;
    float y;
    float z;
    float ringR;
    float pipeR;
} TorusProperty;

typedef struct {
    float x;
    float y;
    float z;
    float capR;
    float height;
} CapsuleProperty;

typedef struct {
    float x;
    float y;
    float z;
    float width;
    float height;
} PlaneProperty;

@interface RCTARKit : ARSCNView

+ (instancetype)sharedInstance;

@property (nonatomic, assign) BOOL debug;
@property (nonatomic, assign) BOOL planeDetection;
@property (nonatomic, assign) BOOL lightEstimation;
@property (nonatomic, readonly) NSDictionary *cameraPosition;

@property (nonatomic, copy) RCTBubblingEventBlock onPlaneDetected;
@property (nonatomic, copy) RCTBubblingEventBlock onPlaneUpdate;

@property NSMutableDictionary *planes;
@property NSMutableArray *boxes;

- (void)snapshot;
- (void)addBox:(BoxProperty)property;
- (void)addSphere:(SphereProperty)property;
- (void)addCylinder:(CylinderProperty)property;
- (void)addCone:(ConeProperty)property;
- (void)addPyramid:(PyramidProperty)property;
- (void)addTube:(TubeProperty)property;
- (void)addTorus:(TorusProperty)property;
- (void)addCapsule:(CapsuleProperty)property;
- (void)addPlane:(PlaneProperty)property;

@end

