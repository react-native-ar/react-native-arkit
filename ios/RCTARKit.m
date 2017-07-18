//
//  RCTARKit.m
//  RCTARKit
//
//  Created by HippoAR on 7/9/17.
//  Copyright © 2017 HippoAR. All rights reserved.
//

#import "RCTARKit.h"
#import "Plane.h"

@interface RCTARKit () <ARSCNViewDelegate> {
    RCTPromiseResolveBlock _resolve;
}

@property (nonatomic, strong) ARWorldTrackingSessionConfiguration *configuration;

@end


@implementation RCTARKit

+ (instancetype)sharedInstance {
    static RCTARKit *arView = nil;
    static dispatch_once_t onceToken;

    dispatch_once(&onceToken, ^{
        if (arView == nil) {
            arView = [[self alloc] init];
        }
    });

    return arView;
}

- (instancetype)init {
    if ((self = [super init])) {
        self.delegate = self;
        [self.session runWithConfiguration:self.configuration];

        self.autoenablesDefaultLighting = YES;
        self.scene = [[SCNScene alloc] init];
        self.planes = [NSMutableDictionary new];
    }
    return self;
}

- (void)pause {
    [self.session pause];
}

- (void)resume {
    [self.session runWithConfiguration:self.configuration];
}

#pragma mark - setter-getter

- (BOOL)debug {
    return self.showsStatistics;
}

- (void)setDebug:(BOOL)debug {
    if (debug) {
        self.showsStatistics = YES;
        self.debugOptions = ARSCNDebugOptionShowWorldOrigin | ARSCNDebugOptionShowFeaturePoints;
    } else {
        self.showsStatistics = NO;
        self.debugOptions = SCNDebugOptionNone;
    }
}

- (BOOL)planeDetection {
    return self.configuration.planeDetection == ARPlaneDetectionHorizontal;
}

- (void)setPlaneDetection:(BOOL)planeDetection {
    if (planeDetection) {
        self.configuration.planeDetection = ARPlaneDetectionHorizontal;
    } else {
        self.configuration.planeDetection = ARPlaneDetectionNone;
    }

    [self.session runWithConfiguration:self.configuration];
}

- (BOOL)lightEstimation {
    return self.configuration.lightEstimationEnabled;
}

- (void)setLightEstimation:(BOOL)lightEstimation {
    self.configuration.lightEstimationEnabled = lightEstimation;
    [self.session runWithConfiguration:self.configuration];
}

- (NSDictionary *)cameraPosition {
    simd_float4 position = self.session.currentFrame.camera.transform.columns[3];
    return @{
             @"x": [NSNumber numberWithFloat:position.x],
             @"y": [NSNumber numberWithFloat:position.y],
             @"z": [NSNumber numberWithFloat:position.z]
             };
}


#pragma mark - Lazy loads

-(ARWorldTrackingSessionConfiguration *)configuration {
    if (_configuration) {
        return _configuration;
    }

    //    if (!ARWorldTrackingSessionConfiguration.isSupported) {
    //    }

    _configuration = [ARWorldTrackingSessionConfiguration new];
    _configuration.planeDetection = ARPlaneDetectionHorizontal;
    return _configuration;
}


#pragma mark - methods

- (void)thisImage:(UIImage *)image savedInAlbumWithError:(NSError *)error ctx:(void *)ctx {
    if (error) {
    } else {
        _resolve(@{ @"success": @(YES) });
    }
}

- (void)snapshot:(RCTPromiseResolveBlock)resolve reject:(RCTPromiseRejectBlock)reject {
    UIImage *image = [super snapshot];
    _resolve = resolve;
    UIImageWriteToSavedPhotosAlbum(image, self, @selector(thisImage:savedInAlbumWithError:ctx:), NULL);
}

- (void)addBox:(BoxProperty)property {
    SCNBox *geometry = [SCNBox boxWithWidth:property.width height:property.height length:property.length chamferRadius:property.chamfer];
    SCNNode *node = [SCNNode nodeWithGeometry:geometry];
    node.position = SCNVector3Make(property.x, property.y, property.z);
    [self.scene.rootNode addChildNode:node];
}

- (void)addSphere:(SphereProperty)property {
    SCNSphere *geometry = [SCNSphere sphereWithRadius:property.radius];
    SCNNode *node = [SCNNode nodeWithGeometry:geometry];
    node.position = SCNVector3Make(property.x, property.y, property.z);
    [self.scene.rootNode addChildNode:node];
}

- (void)addCylinder:(CylinderProperty)property {
    SCNCylinder *geometry = [SCNCylinder cylinderWithRadius:property.radius height:property.height];
    SCNNode *node = [SCNNode nodeWithGeometry:geometry];
    node.position = SCNVector3Make(property.x, property.y, property.z);
    [self.scene.rootNode addChildNode:node];
}

- (void)addCone:(ConeProperty)property {
    SCNCone *geometry = [SCNCone coneWithTopRadius:property.topR bottomRadius:property.bottomR height:property.height];
    SCNNode *node = [SCNNode nodeWithGeometry:geometry];
    node.position = SCNVector3Make(property.x, property.y, property.z);
    [self.scene.rootNode addChildNode:node];
}

- (void)addPyramid:(PyramidProperty)property {
    SCNPyramid *geometry = [SCNPyramid pyramidWithWidth:property.width height:property.height length:property.length];
    SCNNode *node = [SCNNode nodeWithGeometry:geometry];
    node.position = SCNVector3Make(property.x, property.y, property.z);
    [self.scene.rootNode addChildNode:node];
}

- (void)addTube:(TubeProperty)property {
    SCNTube *geometry = [SCNTube tubeWithInnerRadius:property.innerR outerRadius:property.outerR height:property.height];
    SCNNode *node = [SCNNode nodeWithGeometry:geometry];
    node.position = SCNVector3Make(property.x, property.y, property.z);
    [self.scene.rootNode addChildNode:node];
}

- (void)addTorus:(TorusProperty)property {
    SCNTorus *geometry = [SCNTorus torusWithRingRadius:property.ringR pipeRadius:property.pipeR];
    SCNNode *node = [SCNNode nodeWithGeometry:geometry];
    node.position = SCNVector3Make(property.x, property.y, property.z);
    [self.scene.rootNode addChildNode:node];
}

- (void)addCapsule:(CapsuleProperty)property {
    SCNCapsule *geometry = [SCNCapsule capsuleWithCapRadius:property.capR height:property.height];
    SCNNode *node = [SCNNode nodeWithGeometry:geometry];
    node.position = SCNVector3Make(property.x, property.y, property.z);
    [self.scene.rootNode addChildNode:node];
}

- (void)addPlane:(PlaneProperty)property {
    SCNPlane *geometry = [SCNPlane planeWithWidth:property.width height:property.height];
    SCNNode *node = [SCNNode nodeWithGeometry:geometry];
    node.position = SCNVector3Make(property.x, property.y, property.z);
    [self.scene.rootNode addChildNode:node];
}

#pragma mark - ARSCNViewDelegate

/**
 Called when a new node has been added.
 */
- (void)renderer:(id <SCNSceneRenderer>)renderer didAddNode:(SCNNode *)node forAnchor:(ARAnchor *)anchor {
    if (![anchor isKindOfClass:[ARPlaneAnchor class]]) {
        return;
    }

    ARPlaneAnchor *planeAnchor = (ARPlaneAnchor *)anchor;

    if (self.onPlaneDetected) {
        self.onPlaneDetected(@{
                               @"id": planeAnchor.identifier.UUIDString,
                               @"alignment": @(planeAnchor.alignment),
                               @"center": @{ @"x": @(planeAnchor.center.x), @"y": @(planeAnchor.center.y), @"z": @(planeAnchor.center.z) },
                               @"extent": @{ @"x": @(planeAnchor.extent.x), @"y": @(planeAnchor.extent.y), @"z": @(planeAnchor.extent.z) }
                               });
    }

    Plane *plane = [[Plane alloc] initWithAnchor: (ARPlaneAnchor *)anchor isHidden: NO];
    [self.planes setObject:plane forKey:anchor.identifier];
    [node addChildNode:plane];
}

/**
 Called when a node will be updated.
 */
- (void)renderer:(id <SCNSceneRenderer>)renderer willUpdateNode:(SCNNode *)node forAnchor:(ARAnchor *)anchor {
}

/**
 Called when a node has been updated.
 */
- (void)renderer:(id <SCNSceneRenderer>)renderer didUpdateNode:(SCNNode *)node forAnchor:(ARAnchor *)anchor {
    ARPlaneAnchor *planeAnchor = (ARPlaneAnchor *)anchor;

    if (self.onPlaneUpdate) {
        self.onPlaneUpdate(@{
                             @"id": planeAnchor.identifier.UUIDString,
                             @"alignment": @(planeAnchor.alignment),
                             @"center": @{ @"x": @(planeAnchor.center.x), @"y": @(planeAnchor.center.y), @"z": @(planeAnchor.center.z) },
                             @"extent": @{ @"x": @(planeAnchor.extent.x), @"y": @(planeAnchor.extent.y), @"z": @(planeAnchor.extent.z) }
                             });
    }

    Plane *plane = [self.planes objectForKey:anchor.identifier];
    if (plane == nil) {
        return;
    }

    [plane update:(ARPlaneAnchor *)anchor];
}

/**
 Called when a mapped node has been removed.
 */
- (void)renderer:(id <SCNSceneRenderer>)renderer didRemoveNode:(SCNNode *)node forAnchor:(ARAnchor *)anchor {
    [self.planes removeObjectForKey:anchor.identifier];
}

#pragma mark - session

- (void)session:(ARSession *)session didUpdateFrame:(ARFrame *)frame {
    //    simd_float4 position = frame.camera.transform.columns[3];
}

- (void)session:(ARSession *)session didFailWithError:(NSError *)error {
}

- (void)sessionWasInterrupted:(ARSession *)session {
}

- (void)sessionInterruptionEnded:(ARSession *)session {
}

@end
