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
        self.origin = [[SCNNode alloc] init];
        [self.scene.rootNode addChildNode:self.origin];
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
    _configuration.worldAlignment = ARWorldAlignmentGravityAndHeading;
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

- (void)addBox:(NSDictionary *)property {
    float x = [property[@"x"] floatValue];
    float y = [property[@"y"] floatValue];
    float z = [property[@"z"] floatValue];
    float width = [property[@"width"] floatValue];
    float height = [property[@"height"] floatValue];
    float length = [property[@"length"] floatValue];
    float chamfer = [property[@"chamfer"] floatValue];

    SCNBox *geometry = [SCNBox boxWithWidth:width height:height length:length chamferRadius:chamfer];
    SCNNode *node = [SCNNode nodeWithGeometry:geometry];
    node.position = SCNVector3Make(x, y, z);
    [self.origin addChildNode:node];
}

- (void)addSphere:(NSDictionary *)property {
    float x = [property[@"x"] floatValue];
    float y = [property[@"y"] floatValue];
    float z = [property[@"z"] floatValue];
    float radius = [property[@"radius"] floatValue];

    SCNSphere *geometry = [SCNSphere sphereWithRadius:radius];
    SCNNode *node = [SCNNode nodeWithGeometry:geometry];
    node.position = SCNVector3Make(x, y, z);
    [self.origin addChildNode:node];
}

- (void)addCylinder:(NSDictionary *)property {
    float x = [property[@"x"] floatValue];
    float y = [property[@"y"] floatValue];
    float z = [property[@"z"] floatValue];
    float radius = [property[@"radius"] floatValue];
    float height = [property[@"height"] floatValue];

    SCNCylinder *geometry = [SCNCylinder cylinderWithRadius:radius height:height];
    SCNNode *node = [SCNNode nodeWithGeometry:geometry];
    node.position = SCNVector3Make(x, y, z);
    [self.origin addChildNode:node];
}

- (void)addCone:(NSDictionary *)property {
    float x = [property[@"x"] floatValue];
    float y = [property[@"y"] floatValue];
    float z = [property[@"z"] floatValue];
    float topR = [property[@"topR"] floatValue];
    float bottomR = [property[@"bottomR"] floatValue];
    float height = [property[@"height"] floatValue];

    SCNCone *geometry = [SCNCone coneWithTopRadius:topR bottomRadius:bottomR height:height];
    SCNNode *node = [SCNNode nodeWithGeometry:geometry];
    node.position = SCNVector3Make(x, y, z);
    [self.origin addChildNode:node];
}

- (void)addPyramid:(NSDictionary *)property {
    float x = [property[@"x"] floatValue];
    float y = [property[@"y"] floatValue];
    float z = [property[@"z"] floatValue];
    float width = [property[@"width"] floatValue];
    float length = [property[@"length"] floatValue];
    float height = [property[@"height"] floatValue];

    SCNPyramid *geometry = [SCNPyramid pyramidWithWidth:width height:height length:length];
    SCNNode *node = [SCNNode nodeWithGeometry:geometry];
    node.position = SCNVector3Make(x, y, z);
    [self.origin addChildNode:node];
}

- (void)addTube:(NSDictionary *)property {
    float x = [property[@"x"] floatValue];
    float y = [property[@"y"] floatValue];
    float z = [property[@"z"] floatValue];
    float innerR = [property[@"innerR"] floatValue];
    float outerR = [property[@"outerR"] floatValue];
    float height = [property[@"height"] floatValue];
    SCNTube *geometry = [SCNTube tubeWithInnerRadius:innerR outerRadius:outerR height:height];
    SCNNode *node = [SCNNode nodeWithGeometry:geometry];
    node.position = SCNVector3Make(x, y, z);
    [self.origin addChildNode:node];
}

- (void)addTorus:(NSDictionary *)property {
    float x = [property[@"x"] floatValue];
    float y = [property[@"y"] floatValue];
    float z = [property[@"z"] floatValue];
    float ringR = [property[@"ringR"] floatValue];
    float pipeR = [property[@"pipeR"] floatValue];

    SCNTorus *geometry = [SCNTorus torusWithRingRadius:ringR pipeRadius:pipeR];
    SCNNode *node = [SCNNode nodeWithGeometry:geometry];
    node.position = SCNVector3Make(x, y, z);
    [self.origin addChildNode:node];
}

- (void)addCapsule:(NSDictionary *)property {
    float x = [property[@"x"] floatValue];
    float y = [property[@"y"] floatValue];
    float z = [property[@"z"] floatValue];
    float capR = [property[@"capR"] floatValue];
    float height = [property[@"height"] floatValue];

    SCNCapsule *geometry = [SCNCapsule capsuleWithCapRadius:capR height:height];
    SCNNode *node = [SCNNode nodeWithGeometry:geometry];
    node.position = SCNVector3Make(x, y, z);
    [self.origin addChildNode:node];
}

- (void)addPlane:(NSDictionary *)property {
    float x = [property[@"x"] floatValue];
    float y = [property[@"y"] floatValue];
    float z = [property[@"z"] floatValue];
    float width = [property[@"width"] floatValue];
    float height = [property[@"height"] floatValue];

    SCNPlane *geometry = [SCNPlane planeWithWidth:width height:height];
    SCNNode *node = [SCNNode nodeWithGeometry:geometry];
    node.position = SCNVector3Make(x, y, z);
    [self.origin addChildNode:node];
}

- (void)addText:(NSDictionary *)property {
    float x = [property[@"x"] floatValue];
    float y = [property[@"y"] floatValue];
    float z = [property[@"z"] floatValue];
    float fontSize = [property[@"fontSize"] floatValue];
    CGFloat depth = [property[@"depth"] floatValue];

    float size = fontSize / 10;
    SCNText *text = [SCNText textWithString:property[@"text"] extrusionDepth:depth / size];
    text.font = [UIFont systemFontOfSize:10];
    SCNNode *textNode = [SCNNode nodeWithGeometry:text];
    SCNVector3 min;
    SCNVector3 max;
    [textNode getBoundingBoxMin:&min max:&max];
    textNode.position = SCNVector3Make(-(min.x+max.x)/2, -(min.y+max.y)/2, -(min.z+max.z)/2);

    SCNNode *textOrigin = [[SCNNode alloc] init];
    [textOrigin addChildNode:textNode];
    textOrigin.scale = SCNVector3Make(size, size, size);
    textOrigin.position = SCNVector3Make(x, y, z);
    [self.origin addChildNode:textOrigin];
}

- (void)addModel:(NSDictionary *)property {
    float x = [property[@"x"] floatValue];
    float y = [property[@"y"] floatValue];
    float z = [property[@"z"] floatValue];
    float scale = [property[@"scale"] floatValue];

    SCNScene *scene = [SCNScene sceneNamed:property[@"file"]];
    SCNNode *node = [scene.rootNode childNodeWithName:property[@"nodeName"] recursively:YES];
    node.scale = SCNVector3Make(scale, scale, scale);
    node.position = SCNVector3Make(x, y, z);
    [self.origin addChildNode:node];
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
                               @"node": @{ @"x": @(node.position.x), @"y": @(node.position.y), @"z": @(node.position.z) },
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
                             @"node": @{ @"x": @(node.position.x), @"y": @(node.position.y), @"z": @(node.position.z) },
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

- (void)session:(ARSession *)session cameraDidChangeTrackingState:(ARCamera *)camera {
    if (self.onTrackingState) {
        dispatch_async(dispatch_get_main_queue(), ^{
            self.onTrackingState(@{
                                   @"state": @(camera.trackingState),
                                   @"reason": @(camera.trackingStateReason)
                                   });
        });
    }
}

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
