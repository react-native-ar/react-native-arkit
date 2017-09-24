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
#import "RCTARKitDelegate.h"
#import "RCTARKitNodes.h"
#import "RCTARKitIO.h"

@interface RCTARKit : UIView

+ (instancetype)sharedInstance;
- (instancetype)initWithARView:(ARSCNView *)arView;


@property (nonatomic, strong) NSMutableArray<id<RCTARKitTouchDelegate>> *touchDelegates;
@property (nonatomic, strong) NSMutableArray<id<RCTARKitRendererDelegate>> *rendererDelegates;
@property (nonatomic, strong) NSMutableArray<id<RCTARKitSessionDelegate>> *sessionDelegates;


#pragma mark - Properties
@property (nonatomic, strong) ARSCNView *arView;
@property (nonatomic, strong) RCTARKitNodes *nodeManager;
@property (nonatomic, strong) RCTARKitIO *arkitIO;

@property (nonatomic, assign) BOOL debug;
@property (nonatomic, assign) BOOL planeDetection;
@property (nonatomic, assign) BOOL lightEstimation;

@property (nonatomic, copy) RCTBubblingEventBlock onPlaneDetected;
@property (nonatomic, copy) RCTBubblingEventBlock onPlaneUpdate;
@property (nonatomic, copy) RCTBubblingEventBlock onTrackingState;
@property (nonatomic, copy) RCTBubblingEventBlock onTapOnPlaneUsingExtent;
@property (nonatomic, copy) RCTBubblingEventBlock onTapOnPlaneNoExtent;


@property NSMutableDictionary *planes; // plane detected



#pragma mark - Public Method
- (void)pause;
- (void)resume;
- (void)hitTestPlane:(CGPoint)tapPoint types:(ARHitTestResultType)types resolve:(RCTPromiseResolveBlock)resolve reject:(RCTPromiseRejectBlock)reject;
- (void)snapshot:(RCTPromiseResolveBlock)resolve reject:(RCTPromiseRejectBlock)reject;
- (void)snapshotCamera:(RCTPromiseResolveBlock)resolve reject:(RCTPromiseRejectBlock)reject;
- (void)focusScene;
- (NSDictionary *)readCameraPosition;



#pragma mark - Add a model or a geometry
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



#pragma mark - Delegates
- (void)renderer:(id <SCNSceneRenderer>)renderer didRenderScene:(SCNScene *)scene atTime:(NSTimeInterval)time;
- (void)renderer:(id <SCNSceneRenderer>)renderer didAddNode:(SCNNode *)node forAnchor:(ARAnchor *)anchor;
- (void)renderer:(id <SCNSceneRenderer>)renderer willUpdateNode:(SCNNode *)node forAnchor:(ARAnchor *)anchor;
- (void)renderer:(id <SCNSceneRenderer>)renderer didUpdateNode:(SCNNode *)node forAnchor:(ARAnchor *)anchor;
- (void)renderer:(id <SCNSceneRenderer>)renderer didRemoveNode:(SCNNode *)node forAnchor:(ARAnchor *)anchor;

- (void)session:(ARSession *)session didUpdateFrame:(ARFrame *)frame;
- (void)session:(ARSession *)session cameraDidChangeTrackingState:(ARCamera *)camera;

@end



#if __has_include("RCTARKitARCL.h")
#import "RCTARKitARCL.h"
@compatibility_alias ARKit RCTARKitARCL;
#else
@compatibility_alias ARKit RCTARKit;
#endif

