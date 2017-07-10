//
//  RCTARKit.m
//  RCTARKit
//
//  Created by HippoAR on 7/9/17.
//  Copyright © 2017 HippoAR. All rights reserved.
//

#import "RCTARKit.h"
#import <SceneKit/SceneKit.h>
#import <ARKit/ARKit.h>

@interface RCTARKit () <ARSCNViewDelegate>

@property (nonatomic, strong) ARSCNView *sceneView;
@property (nonatomic, strong) ARWorldTrackingSessionConfiguration *configuration;

@end


@implementation RCTARKit

- (instancetype)init {
    if ((self = [super init])) {
        [self addSubview:self.sceneView];
        [self.sceneView.session runWithConfiguration:self.configuration];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    // refresh sceneView frame size
    self.sceneView.frame = self.bounds;
}


#pragma mark - Properties

- (void)setDebug:(BOOL)debug {
    if (debug) {
        self.sceneView.showsStatistics = YES;
        self.sceneView.debugOptions = ARSCNDebugOptionShowWorldOrigin | ARSCNDebugOptionShowFeaturePoints;
    } else {
        self.sceneView.showsStatistics = NO;
        self.sceneView.debugOptions = SCNDebugOptionNone;
    }
}


#pragma mark - Lazy loads

-(ARSCNView *)sceneView {
    if (_sceneView) {
        return _sceneView;
    }
    
    _sceneView = [[ARSCNView alloc] initWithFrame:self.bounds];
    _sceneView.delegate = self;
    
    _sceneView.autoenablesDefaultLighting = YES;
    _sceneView.scene = [SCNScene new];
    
    return _sceneView;
}

-(ARWorldTrackingSessionConfiguration *)configuration {
    if (_configuration) {
        return _configuration;
    }
    
    _configuration = [ARWorldTrackingSessionConfiguration new];
    return _configuration;
}


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

