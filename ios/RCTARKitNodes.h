//
//  RCTARKitNodes.h
//  RCTARKit
//
//  Created by Zehao Li on 9/9/17.
//  Copyright © 2017 HippoAR. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <SceneKit/SceneKit.h>
#import <ARKit/ARKit.h>
#import <React/RCTBridgeModule.h>
#import "RCTARKitDelegate.h"

typedef NS_OPTIONS(NSUInteger, RFReferenceFrame) {
    RFReferenceFrameLocal = 0,
    RFReferenceFrameCamera = 1,
    RFReferenceFrameFrontOfCamera = 2,
    RFReferenceFrameWorld = 3, // to be implemented
};

@interface SCNNode (ReferenceFrame)
@property (nonatomic, assign) RFReferenceFrame referenceFrame;
@end


@interface RCTARKitNodes : NSObject

@property (nonatomic, strong) ARSCNView *arView;

@property (nonatomic, strong) SCNNode *localOrigin;
@property (nonatomic, strong) SCNNode *cameraOrigin;
@property (nonatomic, strong) SCNNode *frontOfCamera;
@property (nonatomic, assign) SCNVector3 cameraDirection;


+ (instancetype)sharedInstance;

- (void)addNodeToScene:(SCNNode *)node property:(NSDictionary *)property;
- (void)clear;

- (void)registerNode:(SCNNode *)node forKey:(NSString *)key;
- (SCNNode *)nodeForKey:(NSString *)key;
- (void)removeNodeForKey:(NSString *)key;
- (NSDictionary *)getSceneObjectsHitResult:(const CGPoint)tapPoint;


@end
