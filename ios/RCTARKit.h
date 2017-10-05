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

#import "RCTARKitDelegate.h"
#import "RCTARKitNodes.h"

typedef void (^RCTBubblingEventBlock)(NSDictionary *body);
typedef void (^RCTARKitResolve)(id result);
typedef void (^RCTARKitReject)(NSString *code, NSString *message, NSError *error);


@interface RCTARKit : UIView

+ (instancetype)sharedInstance;
- (instancetype)initWithARView:(ARSCNView *)arView;


@property (nonatomic, strong) NSMutableArray<id<RCTARKitTouchDelegate>> *touchDelegates;
@property (nonatomic, strong) NSMutableArray<id<RCTARKitRendererDelegate>> *rendererDelegates;
@property (nonatomic, strong) NSMutableArray<id<RCTARKitSessionDelegate>> *sessionDelegates;


#pragma mark - Properties
@property (nonatomic, strong) ARSCNView *arView;
@property (nonatomic, strong) RCTARKitNodes *nodeManager;

@property (nonatomic, assign) BOOL debug;
@property (nonatomic, assign) BOOL planeDetection;
@property (nonatomic, assign) BOOL lightEstimation;

@property (nonatomic, copy) RCTBubblingEventBlock onPlaneDetected;
@property (nonatomic, copy) RCTBubblingEventBlock onPlaneUpdate;
@property (nonatomic, copy) RCTBubblingEventBlock onTrackingState;
@property (nonatomic, copy) RCTBubblingEventBlock onTapOnPlaneUsingExtent;
@property (nonatomic, copy) RCTBubblingEventBlock onTapOnPlaneNoExtent;
@property (nonatomic, copy) RCTBubblingEventBlock onEvent;


@property NSMutableDictionary *planes; // plane detected



#pragma mark - Public Method
- (void)pause;
- (void)resume;
- (void)hitTestPlane:(CGPoint)tapPoint types:(ARHitTestResultType)types resolve:(RCTARKitResolve)resolve reject:(RCTARKitReject)reject;
- (void)hitTestSceneObjects:(CGPoint)tapPoint resolve:(RCTARKitResolve) resolve reject:(RCTARKitReject)reject;
- (SCNVector3)projectPoint:(SCNVector3)point;
- (float)getCameraDistanceToPoint:(SCNVector3)point;
- (void)snapshot:(RCTARKitResolve)resolve reject:(RCTARKitReject)reject;
- (void)snapshotCamera:(RCTARKitResolve)resolve reject:(RCTARKitReject)reject;
- (void)focusScene;
- (void)clearScene;
- (NSDictionary *)readCameraPosition;



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
