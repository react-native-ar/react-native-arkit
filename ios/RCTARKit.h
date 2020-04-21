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
#import "RCTMultiPeer.h"

typedef void (^RCTBubblingEventBlock)(NSDictionary *body);
typedef void (^RCTARKitResolve)(id result);
typedef void (^RCTARKitReject)(NSString *code, NSString *message, NSError *error);


@interface RCTARKit : UIView

+ (instancetype)sharedInstance;
+ (bool)isInitialized;
- (instancetype)initWithARViewAndBrowser:(ARSCNView *)arView multipeer:(MultipeerConnectivity *)multipeer;
- (instancetype)initWithARView:(ARSCNView *)arView;


@property (nonatomic, strong) NSMutableArray<id<RCTARKitTouchDelegate>> *touchDelegates;
@property (nonatomic, strong) NSMutableArray<id<RCTARKitRendererDelegate>> *rendererDelegates;
@property (nonatomic, strong) NSMutableArray<id<RCTARKitSessionDelegate>> *sessionDelegates;
@property (nonatomic, strong) NSMutableArray<id<MultipeerConnectivityDelegate>> *multipeerDelegate;


#pragma mark - Properties
@property (nonatomic, strong) ARSCNView *arView;
@property (nonatomic, strong) MultipeerConnectivity *multipeer;
@property (nonatomic, strong) RCTARKitNodes *nodeManager;

@property (nonatomic, assign) BOOL debug;
@property (nonatomic, assign) ARPlaneDetection planeDetection;
@property (nonatomic, assign) BOOL lightEstimationEnabled;
@property (nonatomic, assign) BOOL autoenablesDefaultLighting;
@property (nonatomic, assign) NSDictionary* origin;
@property (nonatomic, assign) ARWorldAlignment worldAlignment;
@property (nonatomic, assign) NSArray* detectionImages;

@property (nonatomic, copy) RCTBubblingEventBlock onPlaneDetected;
@property (nonatomic, copy) RCTBubblingEventBlock onPlaneRemoved;
@property (nonatomic, copy) RCTBubblingEventBlock onPlaneUpdated;


@property (nonatomic, copy) RCTBubblingEventBlock onAnchorDetected;
@property (nonatomic, copy) RCTBubblingEventBlock onAnchorRemoved;
@property (nonatomic, copy) RCTBubblingEventBlock onAnchorUpdated;


@property (nonatomic, copy) RCTBubblingEventBlock onFeaturesDetected;
@property (nonatomic, copy) RCTBubblingEventBlock onLightEstimation;

@property (nonatomic, copy) RCTBubblingEventBlock onTrackingState;
@property (nonatomic, copy) RCTBubblingEventBlock onTapOnPlaneUsingExtent;
@property (nonatomic, copy) RCTBubblingEventBlock onTapOnPlaneNoExtent;

@property (nonatomic, copy) RCTBubblingEventBlock onRotationGesture;
@property (nonatomic, copy) RCTBubblingEventBlock onPinchGesture;
@property (nonatomic, copy) RCTBubblingEventBlock onPanGestureGesture;



@property (nonatomic, copy) RCTBubblingEventBlock onEvent;
@property (nonatomic, copy) RCTBubblingEventBlock onARKitError;

@property (nonatomic, copy) RCTBubblingEventBlock onPeerConnected;
@property (nonatomic, copy) RCTBubblingEventBlock onPeerConnecting;
@property (nonatomic, copy) RCTBubblingEventBlock onPeerDisconnected;

@property (nonatomic, copy) RCTBubblingEventBlock onMultipeerJsonDataReceived;




@property NSMutableDictionary *planes; // plane detected



#pragma mark - Public Method
- (void)pause;
- (void)resume;
- (void)reset;
- (void)hitTestPlane:(CGPoint)tapPoint types:(ARHitTestResultType)types resolve:(RCTARKitResolve)resolve reject:(RCTARKitReject)reject;
- (void)getCurrentWorldMap:(RCTARKitResolve)resolve reject:(RCTARKitReject)reject;
- (void)hitTestSceneObjects:(CGPoint)tapPoint resolve:(RCTARKitResolve) resolve reject:(RCTARKitReject)reject;
- (SCNVector3)projectPoint:(SCNVector3)point;
- (float)getCameraDistanceToPoint:(SCNVector3)point;
- (UIImage *)getSnapshot:(NSDictionary*)selection;
- (UIImage *)getSnapshotCamera:(NSDictionary*)selection;
- (void)focusScene;
- (void)clearScene;
- (NSDictionary *)readCameraPosition;
- (NSDictionary *)readCamera;
- (NSDictionary* )getCurrentLightEstimation;
- (NSArray * )getCurrentDetectedFeaturePoints;
- (bool)isMounted;
- (void)addRendererDelegates:(id)delegate;
- (void)removeRendererDelegates:(id)delegate;

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
