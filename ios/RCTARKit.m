//
//  RCTARKit.m
//  RCTARKit
//
//  Created by HippoAR on 7/9/17.
//  Copyright © 2017 HippoAR. All rights reserved.
//

#import "RCTARKit.h"

@interface RCTARKit () <ARSCNViewDelegate>

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
        self.scene = [SCNScene new];
    }
    return self;
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

    _configuration = [ARWorldTrackingSessionConfiguration new];
    return _configuration;
}


#pragma mark - methods

#pragma mark - ARSCNViewDelegate

/**
 Called when a new node has been mapped to the given anchor.
 */
- (void)renderer:(id <SCNSceneRenderer>)renderer didAddNode:(SCNNode *)node forAnchor:(ARAnchor *)anchor {
}

/**
 Called when a node will be updated with data from the given anchor.
 */
- (void)renderer:(id <SCNSceneRenderer>)renderer willUpdateNode:(SCNNode *)node forAnchor:(ARAnchor *)anchor {
}

/**
 Called when a node has been updated with data from the given anchor.
 */
- (void)renderer:(id <SCNSceneRenderer>)renderer didUpdateNode:(SCNNode *)node forAnchor:(ARAnchor *)anchor {
}

/**
 Called when a mapped node has been removed from the scene graph for the given anchor.
 */
- (void)renderer:(id <SCNSceneRenderer>)renderer didRemoveNode:(SCNNode *)node forAnchor:(ARAnchor *)anchor {
}

#pragma mark - session

- (void)session:(ARSession *)session didFailWithError:(NSError *)error {
}

- (void)sessionWasInterrupted:(ARSession *)session {
}

- (void)sessionInterruptionEnded:(ARSession *)session {
}

@end
