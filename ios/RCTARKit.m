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

@interface RCTARKit () <ARSCNViewDelegate> {
    RCTPromiseResolveBlock _resolve;
}

@property (nonatomic, strong) ARSession* session;
@property (nonatomic, strong) ARWorldTrackingSessionConfiguration *configuration;

@end


@implementation RCTARKit

+ (instancetype)sharedInstance {
    static RCTARKit *instance = nil;
    static dispatch_once_t onceToken;

    dispatch_once(&onceToken, ^{
        if (instance == nil) {
            ARSCNView *arView = [[ARSCNView alloc] init];
            instance = [[self alloc] initWithARView:arView];
        }
    });
    return instance;
}

- (instancetype)initWithARView:(ARSCNView *)arView {
    if ((self = [super init])) {
        self.arView = arView;

        // delegates
        arView.delegate = self;
        arView.session.delegate = self;

        // configuration(s)
        arView.autoenablesDefaultLighting = YES;
        arView.scene.rootNode.name = @"root";

        // local reference frame origin
        self.localOrigin = [[SCNNode alloc] init];
        self.localOrigin.name = @"localOrigin";
        [arView.scene.rootNode addChildNode:self.localOrigin];

        // camera reference frame origin
        self.cameraOrigin = [[SCNNode alloc] init];
        self.cameraOrigin.name = @"cameraOrigin";
//        self.cameraOrigin.opacity = 0.7;
        [arView.scene.rootNode addChildNode:self.cameraOrigin];

        // init cahces
        self.nodes = [NSMutableDictionary new];
        self.planes = [NSMutableDictionary new];

        // start ARKit
        [self addSubview:arView];
        [self resume];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.arView.frame = self.bounds;
}

- (void)pause {
    [self.session pause];
}

- (void)resume {
    [self.session runWithConfiguration:self.configuration];
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
             @"x": @(self.cameraOrigin.position.x),
             @"y": @(self.cameraOrigin.position.y),
             @"z": @(self.cameraOrigin.position.z)
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



#pragma mark - Methods

- (void)snapshot:(RCTPromiseResolveBlock)resolve reject:(RCTPromiseRejectBlock)reject {
    UIImage *image = [self.arView snapshot];
    _resolve = resolve;
    UIImageWriteToSavedPhotosAlbum(image, self, @selector(thisImage:savedInAlbumWithError:ctx:), NULL);
}

- (void)thisImage:(UIImage *)image savedInAlbumWithError:(NSError *)error ctx:(void *)ctx {
    if (error) {
    } else {
        _resolve(@{ @"success": @(YES) });
    }
}


#pragma mark add models in the scene
- (void)addBox:(NSDictionary *)property {
    CGFloat width = [property[@"width"] floatValue];
    CGFloat height = [property[@"height"] floatValue];
    CGFloat length = [property[@"length"] floatValue];
    CGFloat chamfer = [property[@"chamfer"] floatValue];

    SCNBox *geometry = [SCNBox boxWithWidth:width height:height length:length chamferRadius:chamfer];
    SCNNode *node = [SCNNode nodeWithGeometry:geometry];
    [self addNodeToScene:node property:property];
}

- (void)addSphere:(NSDictionary *)property {
    CGFloat radius = [property[@"radius"] floatValue];

    SCNSphere *geometry = [SCNSphere sphereWithRadius:radius];
    SCNNode *node = [SCNNode nodeWithGeometry:geometry];
    [self addNodeToScene:node property:property];
}

- (void)addCylinder:(NSDictionary *)property {
    CGFloat radius = [property[@"radius"] floatValue];
    CGFloat height = [property[@"height"] floatValue];

    SCNCylinder *geometry = [SCNCylinder cylinderWithRadius:radius height:height];
    SCNNode *node = [SCNNode nodeWithGeometry:geometry];
    [self addNodeToScene:node property:property];
}

- (void)addCone:(NSDictionary *)property {
    CGFloat topR = [property[@"topR"] floatValue];
    CGFloat bottomR = [property[@"bottomR"] floatValue];
    CGFloat height = [property[@"height"] floatValue];

    SCNCone *geometry = [SCNCone coneWithTopRadius:topR bottomRadius:bottomR height:height];
    SCNNode *node = [SCNNode nodeWithGeometry:geometry];
    [self addNodeToScene:node property:property];
}

- (void)addPyramid:(NSDictionary *)property {
    CGFloat width = [property[@"width"] floatValue];
    CGFloat length = [property[@"length"] floatValue];
    CGFloat height = [property[@"height"] floatValue];

    SCNPyramid *geometry = [SCNPyramid pyramidWithWidth:width height:height length:length];
    SCNNode *node = [SCNNode nodeWithGeometry:geometry];
    [self addNodeToScene:node property:property];
}

- (void)addTube:(NSDictionary *)property {
    CGFloat innerR = [property[@"innerR"] floatValue];
    CGFloat outerR = [property[@"outerR"] floatValue];
    CGFloat height = [property[@"height"] floatValue];
    SCNTube *geometry = [SCNTube tubeWithInnerRadius:innerR outerRadius:outerR height:height];
    SCNNode *node = [SCNNode nodeWithGeometry:geometry];
    [self addNodeToScene:node property:property];
}

- (void)addTorus:(NSDictionary *)property {
    CGFloat ringR = [property[@"ringR"] floatValue];
    CGFloat pipeR = [property[@"pipeR"] floatValue];

    SCNTorus *geometry = [SCNTorus torusWithRingRadius:ringR pipeRadius:pipeR];
    SCNNode *node = [SCNNode nodeWithGeometry:geometry];
    [self addNodeToScene:node property:property];
}

- (void)addCapsule:(NSDictionary *)property {
    CGFloat capR = [property[@"capR"] floatValue];
    CGFloat height = [property[@"height"] floatValue];

    SCNCapsule *geometry = [SCNCapsule capsuleWithCapRadius:capR height:height];
    SCNNode *node = [SCNNode nodeWithGeometry:geometry];
    [self addNodeToScene:node property:property];
}

- (void)addPlane:(NSDictionary *)property {
    CGFloat width = [property[@"width"] floatValue];
    CGFloat height = [property[@"height"] floatValue];

    SCNPlane *geometry = [SCNPlane planeWithWidth:width height:height];
    SCNNode *node = [SCNNode nodeWithGeometry:geometry];
    [self addNodeToScene:node property:property];
}

- (void)addText:(NSDictionary *)property {
    // init SCNText
    NSString *text = property[@"text"];
    CGFloat depth = [property[@"depth"] floatValue];
    if (!text) {
        text = @"(null)";
    }
    if (!depth) {
        depth = 0.0f;
    }
    CGFloat fontSize = [property[@"size"] floatValue];
    CGFloat size = fontSize / 12;
    SCNText *scnText = [SCNText textWithString:text extrusionDepth:depth / size];
    scnText.flatness = 0.1;

    // font
    NSString *font = property[@"name"];
    if (font) {
        scnText.font = [UIFont fontWithName:font size:12];
    } else {
        scnText.font = [UIFont systemFontOfSize:12];
    }

    // chamfer
    CGFloat chamfer = [property[@"chamfer"] floatValue];
    if (!chamfer) {
        chamfer = 0.0f;
    }
    scnText.chamferRadius = chamfer / size;

    // color
    if (property[@"color"]) {
        CGFloat r = [property[@"r"] floatValue];
        CGFloat g = [property[@"g"] floatValue];
        CGFloat b = [property[@"b"] floatValue];
        SCNMaterial *face = [SCNMaterial new];
        face.diffuse.contents = [[UIColor alloc] initWithRed:r green:g blue:b alpha:1.0f];
        SCNMaterial *border = [SCNMaterial new];
        border.diffuse.contents = [[UIColor alloc] initWithRed:r green:g blue:b alpha:1.0f];
        scnText.materials = @[face, face, border, border, border];
    }

    // init SCNNode
    SCNNode *textNode = [SCNNode nodeWithGeometry:scnText];

    // position textNode
    SCNVector3 min, max;
    [textNode getBoundingBoxMin:&min max:&max];
    textNode.position = SCNVector3Make(-(min.x + max.x) / 2, -(min.y + max.y) / 2, -(min.z + max.z) / 2);

    SCNNode *textOrigin = [[SCNNode alloc] init];
    [textOrigin addChildNode:textNode];
    textOrigin.scale = SCNVector3Make(size, size, size);
    [self addNodeToScene:textOrigin property:property];
}

- (void)addModel:(NSDictionary *)property {
    CGFloat scale = [property[@"scale"] floatValue];

    SCNNode *node = [self loadModel:property[@"file"] nodeName:property[@"node"] withAnimation:YES];
    node.scale = SCNVector3Make(scale, scale, scale);
    [self addNodeToScene:node property:property];
}


#pragma mark model loader

- (SCNNode *)loadModel:(NSString *)path nodeName:(NSString *)nodeName withAnimation:(BOOL)withAnimation {
    NSURL *url = [NSURL URLWithString:[path stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]];
    SCNScene *scene = [SCNScene sceneWithURL:url options:nil error:nil];
    
    SCNNode *node;
    if (nodeName) {
        node = [scene.rootNode childNodeWithName:nodeName recursively:YES];
    } else {
        node = [[SCNNode alloc] init];
        NSArray *nodeArray = [scene.rootNode childNodes];
        for (SCNNode *eachChild in nodeArray) {
            [node addChildNode:eachChild];
        }
    }
    
    if (withAnimation) {
        NSMutableArray *animationMutableArray = [NSMutableArray array];
        SCNSceneSource *sceneSource = [SCNSceneSource sceneSourceWithURL:url options:@{SCNSceneSourceAnimationImportPolicyKey:SCNSceneSourceAnimationImportPolicyPlayRepeatedly}];

        NSArray *animationIds = [sceneSource identifiersOfEntriesWithClass:[CAAnimation class]];
        for (NSString *eachId in animationIds){
            CAAnimation *animation = [sceneSource entryWithIdentifier:eachId withClass:[CAAnimation class]];
            [animationMutableArray addObject:animation];
        }
        NSArray *animationArray = [NSArray arrayWithArray:animationMutableArray];

        int i = 1;
        for (CAAnimation *animation in animationArray) {
            NSString *key = [NSString stringWithFormat:@"ANIM_%d", i];
            [node addAnimation:animation forKey:key];
            i++;
        }
    }

    return node;
}


#pragma mark executors of adding node to scene

- (void)addNodeToScene:(SCNNode *)node property:(NSDictionary *)property {
    node.position = [self getPositionFromProperty:property];

    NSString *key = [NSString stringWithFormat:@"%@", property[@"id"]];
    if (key) {
        [self registerNode:node forKey:key];
    }
    [self.localOrigin addChildNode:node];
}

- (SCNVector3)getPositionFromProperty:(NSDictionary *)property {
    CGFloat x = [property[@"x"] floatValue];
    CGFloat y = [property[@"y"] floatValue];
    CGFloat z = [property[@"z"] floatValue];

    if (property[@"x"] == NULL) {
        x = self.cameraOrigin.position.x - self.localOrigin.position.x;
    }
    if (property[@"y"] == NULL) {
        y = self.cameraOrigin.position.y - self.localOrigin.position.y;
    }
    if (property[@"z"] == NULL) {
        z = self.cameraOrigin.position.z - self.localOrigin.position.z;
    }

    return SCNVector3Make(x, y, z);
}


#pragma mark node register

- (void)registerNode:(SCNNode *)node forKey:(NSString *)key {
    [self removeNodeForKey:key];
    [self.nodes setObject:node forKey:key];
}

- (SCNNode *)nodeForKey:(NSString *)key {
    return [self.nodes objectForKey:key];
}

- (void)removeNodeForKey:(NSString *)key {
    SCNNode *node = [self.nodes objectForKey:key];
    if (node == nil) {
        return;
    }
    [node removeFromParentNode];
    [self.nodes removeObjectForKey:key];
}



#pragma mark - ARSCNViewDelegate

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
    //            @"camera": @{ @"x": @(self.cameraOrigin.position.x), @"y": @(self.cameraOrigin.position.y), @"z": @(self.cameraOrigin.position.z) }
    //            });

    if (self.onPlaneDetected) {
        self.onPlaneDetected(@{
                               @"id": planeAnchor.identifier.UUIDString,
                               @"alignment": @(planeAnchor.alignment),
                               @"node": @{ @"x": @(node.position.x), @"y": @(node.position.y), @"z": @(node.position.z) },
                               @"center": @{ @"x": @(planeAnchor.center.x), @"y": @(planeAnchor.center.y), @"z": @(planeAnchor.center.z) },
                               @"extent": @{ @"x": @(planeAnchor.extent.x), @"y": @(planeAnchor.extent.y), @"z": @(planeAnchor.extent.z) },
                               @"camera": @{ @"x": @(self.cameraOrigin.position.x), @"y": @(self.cameraOrigin.position.y), @"z": @(self.cameraOrigin.position.z) }
                               });
    }

    Plane *plane = [[Plane alloc] initWithAnchor: (ARPlaneAnchor *)anchor isHidden: NO];
    [self.planes setObject:plane forKey:anchor.identifier];
    [node addChildNode:plane];
}

- (void)renderer:(id <SCNSceneRenderer>)renderer willUpdateNode:(SCNNode *)node forAnchor:(ARAnchor *)anchor {
}

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
    //                   @"camera": @{ @"x": @(self.cameraOrigin.position.x), @"y": @(self.cameraOrigin.position.y), @"z": @(self.cameraOrigin.position.z) }
    //                   });

    if (self.onPlaneUpdate) {
        self.onPlaneUpdate(@{
                             @"id": planeAnchor.identifier.UUIDString,
                             @"alignment": @(planeAnchor.alignment),
                             @"node": @{ @"x": @(node.position.x), @"y": @(node.position.y), @"z": @(node.position.z) },
                             @"center": @{ @"x": @(planeAnchor.center.x), @"y": @(planeAnchor.center.y), @"z": @(planeAnchor.center.z) },
                             @"extent": @{ @"x": @(planeAnchor.extent.x), @"y": @(planeAnchor.extent.y), @"z": @(planeAnchor.extent.z) },
                             @"camera": @{ @"x": @(self.cameraOrigin.position.x), @"y": @(self.cameraOrigin.position.y), @"z": @(self.cameraOrigin.position.z) }
                             });
    }

    Plane *plane = [self.planes objectForKey:anchor.identifier];
    if (plane == nil) {
        return;
    }

    [plane update:(ARPlaneAnchor *)anchor];
}

- (void)renderer:(id <SCNSceneRenderer>)renderer didRemoveNode:(SCNNode *)node forAnchor:(ARAnchor *)anchor {
    [self.planes removeObjectForKey:anchor.identifier];
}


#pragma mark - ARSessionDelegate

- (void)session:(ARSession *)session didUpdateFrame:(ARFrame *)frame {
//    self.cameraOrigin.transform = self.arView.pointOfView.transform;

    simd_float4 pos = frame.camera.transform.columns[3];
    self.cameraOrigin.position = SCNVector3Make(pos.x, pos.y, pos.z);
    simd_float4 z = frame.camera.transform.columns[2];
    self.cameraOrigin.eulerAngles = SCNVector3Make(0, atan2f(z.x, z.z), 0);
}

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


#pragma mark - dealloc
-(void) dealloc {
}

@end
