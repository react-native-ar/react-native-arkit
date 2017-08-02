//
//  RCTARKit.m
//  RCTARKit
//
//  Created by HippoAR on 7/9/17.
//  Copyright © 2017 HippoAR. All rights reserved.
//

#import "RCTARKit.h"
#import "Plane.h"
@import CoreLocation;

#if __has_include("ARCL/ARCL-Swift.h")
#import <ARCL/ARCL-Swift.h>
@class SceneLocationView;
@class AnnotationNode;
@class LocationAnnotationNode;
#endif

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

#if __has_include("ARCL/ARCL-Swift.h")
        NSLog(@"Running in ARCL mode");
        self.arView = [[SceneLocationView alloc] init];
#else
        NSLog(@"Running in regular ARKit mode");
        self.arView = [[ARSCNView alloc] init];
#endif

        self.arView.delegate = self;
        self.arView.session.delegate = self;

        self.arView.autoenablesDefaultLighting = YES;

        self.origin = [[SCNNode alloc] init];
        self.origin.name = @"origin";
        [self.arView.scene.rootNode addChildNode:self.origin];
        self.arView.scene.rootNode.name = @"root";
        self.planes = [NSMutableDictionary new];

        [self addSubview:self.arView];

        [self resume];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.arView.frame = self.bounds;
}

- (void)pause {
#if __has_include("ARCL/ARCL-Swift.h")
    [self.arView pause];
#else
    [self.session pause];
#endif
}

- (void)resume {
#if __has_include("ARCL/ARCL-Swift.h")
    [self.arView run];
#else
    [self.session runWithConfiguration:self.configuration];
#endif
}

#pragma mark - setter-getter

- (ARSession*)session {
    return self.arView.session;
}

- (BOOL)debug {
    return self.arView.showsStatistics;
}

- (void)setDebug:(BOOL)debug {
    if (debug) {
        self.arView.showsStatistics = YES;
        self.arView.debugOptions = ARSCNDebugOptionShowWorldOrigin | ARSCNDebugOptionShowFeaturePoints;
    } else {
        self.arView.showsStatistics = NO;
        self.arView.debugOptions = SCNDebugOptionNone;
    }
}

- (BOOL)planeDetection {
    ARWorldTrackingSessionConfiguration *configuration = self.session.configuration;
    return configuration.planeDetection == ARPlaneDetectionHorizontal;
}

- (void)setPlaneDetection:(BOOL)planeDetection {
    // plane detection is on by default for ARCL and cannot be configured for now
    ARWorldTrackingSessionConfiguration *configuration = self.session.configuration;
    if (planeDetection) {
        configuration.planeDetection = ARPlaneDetectionHorizontal;
    } else {
        configuration.planeDetection = ARPlaneDetectionNone;
    }
    [self resume];
}

- (BOOL)lightEstimation {
    ARSessionConfiguration *configuration = self.session.configuration;
    return configuration.lightEstimationEnabled;
}

- (void)setLightEstimation:(BOOL)lightEstimation {
    // light estimation is on by default for ARCL and cannot be configured for now
    ARSessionConfiguration *configuration = self.session.configuration;
    configuration.lightEstimationEnabled = lightEstimation;
    [self resume];
}

- (NSDictionary *)readCameraPosition {
    return @{
             @"x": @(self.cameraPosition.x),
             @"y": @(self.cameraPosition.y),
             @"z": @(self.cameraPosition.z)
             };
}

#pragma mark - Lazy loads

-(ARWorldTrackingSessionConfiguration *)configuration {
    if (_configuration) {
        return _configuration;
    }

    if (!ARWorldTrackingSessionConfiguration.isSupported) {}

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
    UIImage *image = [self.arView snapshot];
    _resolve = resolve;
    UIImageWriteToSavedPhotosAlbum(image, self, @selector(thisImage:savedInAlbumWithError:ctx:), NULL);
}

- (void)addBox:(NSDictionary *)property {
    float width = [property[@"width"] floatValue];
    float height = [property[@"height"] floatValue];
    float length = [property[@"length"] floatValue];
    float chamfer = [property[@"chamfer"] floatValue];

    SCNBox *geometry = [SCNBox boxWithWidth:width height:height length:length chamferRadius:chamfer];
    SCNNode *node = [SCNNode nodeWithGeometry:geometry];
    [self addNodeToScene:node property:property];
}

- (void)addSphere:(NSDictionary *)property {
    float radius = [property[@"radius"] floatValue];

    SCNSphere *geometry = [SCNSphere sphereWithRadius:radius];
    SCNNode *node = [SCNNode nodeWithGeometry:geometry];
    [self addNodeToScene:node property:property];
}

- (void)addCylinder:(NSDictionary *)property {
    float radius = [property[@"radius"] floatValue];
    float height = [property[@"height"] floatValue];

    SCNCylinder *geometry = [SCNCylinder cylinderWithRadius:radius height:height];
    SCNNode *node = [SCNNode nodeWithGeometry:geometry];
    [self addNodeToScene:node property:property];
}

- (void)addCone:(NSDictionary *)property {
    float topR = [property[@"topR"] floatValue];
    float bottomR = [property[@"bottomR"] floatValue];
    float height = [property[@"height"] floatValue];

    SCNCone *geometry = [SCNCone coneWithTopRadius:topR bottomRadius:bottomR height:height];
    SCNNode *node = [SCNNode nodeWithGeometry:geometry];
    [self addNodeToScene:node property:property];
}

- (void)addPyramid:(NSDictionary *)property {
    float width = [property[@"width"] floatValue];
    float length = [property[@"length"] floatValue];
    float height = [property[@"height"] floatValue];

    SCNPyramid *geometry = [SCNPyramid pyramidWithWidth:width height:height length:length];
    SCNNode *node = [SCNNode nodeWithGeometry:geometry];
    [self addNodeToScene:node property:property];
}

- (void)addTube:(NSDictionary *)property {
    float innerR = [property[@"innerR"] floatValue];
    float outerR = [property[@"outerR"] floatValue];
    float height = [property[@"height"] floatValue];
    SCNTube *geometry = [SCNTube tubeWithInnerRadius:innerR outerRadius:outerR height:height];
    SCNNode *node = [SCNNode nodeWithGeometry:geometry];
    [self addNodeToScene:node property:property];
}

- (void)addTorus:(NSDictionary *)property {
    float ringR = [property[@"ringR"] floatValue];
    float pipeR = [property[@"pipeR"] floatValue];

    SCNTorus *geometry = [SCNTorus torusWithRingRadius:ringR pipeRadius:pipeR];
    SCNNode *node = [SCNNode nodeWithGeometry:geometry];
    [self addNodeToScene:node property:property];
}

- (void)addCapsule:(NSDictionary *)property {
    float capR = [property[@"capR"] floatValue];
    float height = [property[@"height"] floatValue];

    SCNCapsule *geometry = [SCNCapsule capsuleWithCapRadius:capR height:height];
    SCNNode *node = [SCNNode nodeWithGeometry:geometry];
    [self addNodeToScene:node property:property];
}

- (void)addPlane:(NSDictionary *)property {
    float width = [property[@"width"] floatValue];
    float height = [property[@"height"] floatValue];

    SCNPlane *geometry = [SCNPlane planeWithWidth:width height:height];
    SCNNode *node = [SCNNode nodeWithGeometry:geometry];
    [self addNodeToScene:node property:property];
}

- (void)addText:(NSDictionary *)property {
    NSString *font = property[@"font"];
    NSString *text = property[@"text"];
    float fontSize = [property[@"fontSize"] floatValue];
    CGFloat depth = [property[@"depth"] floatValue];
    float chamfer = [property[@"chamfer"] floatValue];
    if (!depth) {
        depth = 0.0f;
    }
    if (!chamfer) {
        chamfer = 0.0f;
    }
    if (!text) {
        text = @"(null)";
    }

    float size = fontSize / 12;
    SCNText *scnText = [SCNText textWithString:text extrusionDepth:depth / size];
    NSArray<NSString *> *xx = [UIFont fontNamesForFamilyName:@"Source Sans Pro"];

    for (NSString *x in xx){
        NSLog(@"%@", x);
    }


    if (font) {
        scnText.font = [UIFont fontWithName:font size:12];
    } else {
        scnText.font = [UIFont systemFontOfSize:12];
    }
    scnText.flatness = 0.1;
    scnText.chamferRadius = chamfer / size;
    SCNNode *textNode = [SCNNode nodeWithGeometry:scnText];
    SCNVector3 min;
    SCNVector3 max;
    [textNode getBoundingBoxMin:&min max:&max];
    textNode.position = SCNVector3Make(-(min.x+max.x)/2, -(min.y+max.y)/2, -(min.z+max.z)/2);


    CGFloat r = [property[@"r"] floatValue];
    CGFloat g = [property[@"g"] floatValue];
    CGFloat b = [property[@"b"] floatValue];
    if (!r) {
        r = 0.0f;
    }
    if (!g) {
        g = 0.0f;
    }
    if (!b) {
        b = 0.0f;
    }

    SCNMaterial *face = [SCNMaterial new];
    face.diffuse.contents = [[UIColor alloc] initWithRed:r green:g blue:b alpha:1.0f];
    SCNMaterial *border = [SCNMaterial new];
    border.diffuse.contents = [[UIColor alloc] initWithRed:r green:g blue:b alpha:1.0f];
    scnText.materials = @[face, face, border, border, border];

    SCNNode *textOrigin = [[SCNNode alloc] init];
    [textOrigin addChildNode:textNode];
    textOrigin.scale = SCNVector3Make(size, size, size);
    [self addNodeToScene:textOrigin property:property];
}

- (void)addModel:(NSDictionary *)property {
    float scale = [property[@"scale"] floatValue];

    SCNScene *scene = [SCNScene sceneNamed:property[@"file"]];
    SCNNode *node = [scene.rootNode childNodeWithName:property[@"nodeName"] recursively:YES];
    node.scale = SCNVector3Make(scale, scale, scale);
    [self addNodeToScene:node property:property];
}

- (void)addImage:(NSDictionary *)property {
#if __has_include("ARCL/ARCL-Swift.h")
    CLLocation *current = [self.arView currentLocation];
    CLLocationCoordinate2D coord;
    coord.longitude = [property[@"longitude"] floatValue];
    coord.latitude = [property[@"latitude"] floatValue];
    CLLocation *loc = [[CLLocation alloc] initWithCoordinate:coord altitude:current.altitude horizontalAccuracy:0 verticalAccuracy:0 timestamp:nil];

    UIImage *img = [UIImage imageNamed:property[@"image"]];
    LocationAnnotationNode *locNode = [[LocationAnnotationNode alloc] initWithLocation:loc image:img];
    locNode.scaleRelativeToDistance = YES;
    [self.arView addLocationNodeWithConfirmedLocationWithLocationNode:locNode];
#endif
}

- (SCNVector3)getPositionFromProperty:(NSDictionary *)property {
    float x = [property[@"x"] floatValue];
    float y = [property[@"y"] floatValue];
    float z = [property[@"z"] floatValue];

    if (property[@"x"] == NULL) {
        x = self.cameraPosition.x - self.origin.position.x;
    }
    if (property[@"y"] == NULL) {
        y = self.cameraPosition.y - self.origin.position.y;
    }
    if (property[@"z"] == NULL) {
        z = self.cameraPosition.z - self.origin.position.z;
    }
    return SCNVector3Make(x, y, z);
}

- (void)addNodeToScene:(SCNNode *)node property:(NSDictionary *)property {
#if __has_include("ARCL/ARCL-Swift.h")
    if (property[@"longitude"] && property[@"longitude"]) {
        CLLocation *current = [self.arView currentLocation];
        CLLocationCoordinate2D coord;
        coord.longitude = [property[@"longitude"] floatValue];
        coord.latitude = [property[@"latitude"] floatValue];
        CLLocation *loc = [[CLLocation alloc] initWithCoordinate:coord altitude:current.altitude horizontalAccuracy:0 verticalAccuracy:0 timestamp:nil];

        LocationNode *locNode = [[LocationNode alloc] initWithLocation:loc];
        [locNode addChildNode:node];
        [self.arView addLocationNodeWithConfirmedLocationWithLocationNode:locNode];
    } else {
        LocationNode *locNode = [[LocationNode alloc] initWithLocation:nil];
        [locNode addChildNode:node];
        [self.arView addLocationNodeForCurrentPositionWithLocationNode:locNode];
    }
#else
    node.position = [self getPositionFromProperty:property];
    [self.origin addChildNode:node];
#endif
}

#pragma mark - ARSCNViewDelegate

/**
 Called when a new node has been added.
 */
- (void)renderer:(id <SCNSceneRenderer>)renderer didAddNode:(SCNNode *)node forAnchor:(ARAnchor *)anchor {
    if (![anchor isKindOfClass:[ARPlaneAnchor class]]) {
        return;
    }

    SCNNode *parent = [node parentNode];
    NSLog(@"plane detected");
    //    NSLog(@"%f %f %f", parent.position.x, parent.position.y, parent.position.z);

    ARPlaneAnchor *planeAnchor = (ARPlaneAnchor *)anchor;

    //    NSLog(@"%@", @{
    //            @"id": planeAnchor.identifier.UUIDString,
    //            @"alignment": @(planeAnchor.alignment),
    //            @"node": @{ @"x": @(node.position.x), @"y": @(node.position.y), @"z": @(node.position.z) },
    //            @"center": @{ @"x": @(planeAnchor.center.x), @"y": @(planeAnchor.center.y), @"z": @(planeAnchor.center.z) },
    //            @"extent": @{ @"x": @(planeAnchor.extent.x), @"y": @(planeAnchor.extent.y), @"z": @(planeAnchor.extent.z) },
    //            @"camera": @{ @"x": @(self.cameraPosition.x), @"y": @(self.cameraPosition.y), @"z": @(self.cameraPosition.z) }
    //            });

    if (self.onPlaneDetected) {
        self.onPlaneDetected(@{
                               @"id": planeAnchor.identifier.UUIDString,
                               @"alignment": @(planeAnchor.alignment),
                               @"node": @{ @"x": @(node.position.x), @"y": @(node.position.y), @"z": @(node.position.z) },
                               @"center": @{ @"x": @(planeAnchor.center.x), @"y": @(planeAnchor.center.y), @"z": @(planeAnchor.center.z) },
                               @"extent": @{ @"x": @(planeAnchor.extent.x), @"y": @(planeAnchor.extent.y), @"z": @(planeAnchor.extent.z) },
                               @"camera": @{ @"x": @(self.cameraPosition.x), @"y": @(self.cameraPosition.y), @"z": @(self.cameraPosition.z) }
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

    SCNNode *parent = [node parentNode];
    //    NSLog(@"%@", parent.name);
    //    NSLog(@"%f %f %f", node.position.x, node.position.y, node.position.z);
    //    NSLog(@"%f %f %f %f", node.rotation.x, node.rotation.y, node.rotation.z, node.rotation.w);


    //    NSLog(@"%@", @{
    //                   @"id": planeAnchor.identifier.UUIDString,
    //                   @"alignment": @(planeAnchor.alignment),
    //                   @"node": @{ @"x": @(node.position.x), @"y": @(node.position.y), @"z": @(node.position.z) },
    //                   @"center": @{ @"x": @(planeAnchor.center.x), @"y": @(planeAnchor.center.y), @"z": @(planeAnchor.center.z) },
    //                   @"extent": @{ @"x": @(planeAnchor.extent.x), @"y": @(planeAnchor.extent.y), @"z": @(planeAnchor.extent.z) },
    //                   @"camera": @{ @"x": @(self.cameraPosition.x), @"y": @(self.cameraPosition.y), @"z": @(self.cameraPosition.z) }
    //                   });

    if (self.onPlaneUpdate) {
        self.onPlaneUpdate(@{
                             @"id": planeAnchor.identifier.UUIDString,
                             @"alignment": @(planeAnchor.alignment),
                             @"node": @{ @"x": @(node.position.x), @"y": @(node.position.y), @"z": @(node.position.z) },
                             @"center": @{ @"x": @(planeAnchor.center.x), @"y": @(planeAnchor.center.y), @"z": @(planeAnchor.center.z) },
                             @"extent": @{ @"x": @(planeAnchor.extent.x), @"y": @(planeAnchor.extent.y), @"z": @(planeAnchor.extent.z) },
                             @"camera": @{ @"x": @(self.cameraPosition.x), @"y": @(self.cameraPosition.y), @"z": @(self.cameraPosition.z) }
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


- (void)renderer:(id <SCNSceneRenderer>)renderer didRenderScene:(SCNScene *)scene atTime:(NSTimeInterval)time {
#if __has_include("ARCL/ARCL-Swift.h")
    [self.arView renderer:renderer didRenderScene:scene atTime:time];
#endif
}


#pragma mark - session

- (void)session:(ARSession *)session didUpdateFrame:(ARFrame *)frame {
    simd_float4 pos = frame.camera.transform.columns[3];
    //    NSLog(@"camera %f %f %f", pos.x, pos.y, pos.z);
    self.cameraPosition = SCNVector3Make(pos.x, pos.y, pos.z);
}

- (void)session:(ARSession *)session cameraDidChangeTrackingState:(ARCamera *)camera {
#if __has_include("ARCL/ARCL-Swift.h")
    [self.arView session:session cameraDidChangeTrackingState:camera];
#endif

    if (self.onTrackingState) {
        dispatch_async(dispatch_get_main_queue(), ^{
            self.onTrackingState(@{
                                   @"state": @(camera.trackingState),
                                   @"reason": @(camera.trackingStateReason)
                                   });
        });
    }
}

- (void)session:(ARSession *)session didFailWithError:(NSError *)error {
#if __has_include("ARCL/ARCL-Swift.h")
    [self.arView session:session didFailWithError:error];
#endif
}

- (void)sessionWasInterrupted:(ARSession *)session {
#if __has_include("ARCL/ARCL-Swift.h")
    [self.arView sessionWasInterrupted:session];
#endif
}

- (void)sessionInterruptionEnded:(ARSession *)session {
#if __has_include("ARCL/ARCL-Swift.h")
    [self.arView sessionInterruptionEnded:session];
#endif
}

@end
