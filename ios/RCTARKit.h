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
#import <React/RCTBridgeModule.h>

#if __has_include("ARCL/ARCL-Swift.h")
#import <ARCL/ARCL-Swift.h>
@class SceneLocationView;
#endif

@interface RCTARKit : UIView

+ (instancetype)sharedInstance;

@property (nonatomic, strong) ARWorldTrackingSessionConfiguration *configuration;

#if __has_include("ARCL/ARCL-Swift.h")
@property (nonatomic, strong) SceneLocationView* arView;
#else
@property (nonatomic, strong) ARSCNView* arView;
#endif

@property (nonatomic, strong) ARSession* session;

@property (nonatomic, assign) BOOL debug;
@property (nonatomic, assign) BOOL planeDetection;
@property (nonatomic, assign) BOOL lightEstimation;
@property (nonatomic, assign) SCNVector3 cameraPosition;

@property (nonatomic, copy) RCTBubblingEventBlock onPlaneDetected;
@property (nonatomic, copy) RCTBubblingEventBlock onPlaneUpdate;
@property (nonatomic, copy) RCTBubblingEventBlock onTrackingState;

@property (nonatomic, strong) SCNNode *origin;

@property NSMutableDictionary *planes;
@property NSMutableArray *boxes;

- (NSDictionary *)readCameraPosition;
- (void)snapshot:(RCTPromiseResolveBlock)resolve reject:(RCTPromiseRejectBlock)reject;
- (void)pause;
- (void)resume;

- (void)addBox:(NSDictionary *)property;
- (void)addSphere:(NSDictionary *)property;
- (void)addCylinder:(NSDictionary *)property;
- (void)addCone:(NSDictionary *)property;
- (void)addPyramid:(NSDictionary *)property;
- (void)addTube:(NSDictionary *)property;
- (void)addTorus:(NSDictionary *)property;
- (void)addCapsule:(NSDictionary *)property;
- (void)addPlane:(NSDictionary *)property;
- (void)addText:(NSDictionary *)property;
- (void)addModel:(NSDictionary *)property;
- (void)addImage:(NSDictionary *)property;

- (void)renderer:(id <SCNSceneRenderer>)renderer didAddNode:(SCNNode *)node forAnchor:(ARAnchor *)anchor;
- (void)renderer:(id <SCNSceneRenderer>)renderer didUpdateNode:(SCNNode *)node forAnchor:(ARAnchor *)anchor;
- (void)session:(ARSession *)session didUpdateFrame:(ARFrame *)frame;

@end
