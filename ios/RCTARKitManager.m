//
//  RCTARKitManager.m
//  RCTARKit
//
//  Created by HippoAR on 7/9/17.
//  Copyright © 2017 HippoAR. All rights reserved.
//

#import "RCTARKitManager.h"
#import "RCTARKit.h"
#import "RCTARKitNodes.h"

@implementation RCTARKitManager

RCT_EXPORT_MODULE()

- (UIView *)view {
    return [ARKit sharedInstance];
}

- (NSDictionary *)constantsToExport
{
    return @{
             @"ARHitTestResultType": @{
                     @"FeaturePoint": @(ARHitTestResultTypeFeaturePoint),
                     @"EstimatedHorizontalPlane": @(ARHitTestResultTypeEstimatedHorizontalPlane),
                     @"ExistingPlane": @(ARHitTestResultTypeExistingPlane),
                     @"ExistingPlaneUsingExtent": @(ARHitTestResultTypeExistingPlaneUsingExtent)
                     },
             @"LightingModel": @{
                     @"Constant": SCNLightingModelConstant,
                     @"Blinn": SCNLightingModelBlinn,
                     @"Lambert": SCNLightingModelLambert,
                     @"Phong": SCNLightingModelPhong,
                     @"PhysicallyBased": SCNLightingModelPhysicallyBased
                     }
             };
}

RCT_EXPORT_VIEW_PROPERTY(debug, BOOL)
RCT_EXPORT_VIEW_PROPERTY(planeDetection, BOOL)
RCT_EXPORT_VIEW_PROPERTY(lightEstimation, BOOL)

RCT_EXPORT_VIEW_PROPERTY(onPlaneDetected, RCTBubblingEventBlock)
RCT_EXPORT_VIEW_PROPERTY(onPlaneUpdate, RCTBubblingEventBlock)
RCT_EXPORT_VIEW_PROPERTY(onTrackingState, RCTBubblingEventBlock)
RCT_EXPORT_VIEW_PROPERTY(onEvent, RCTBubblingEventBlock)

RCT_EXPORT_METHOD(pause:(RCTPromiseResolveBlock)resolve reject:(RCTPromiseRejectBlock)reject) {
    [[ARKit sharedInstance] pause];
    resolve(@{});
}

RCT_EXPORT_METHOD(resume:(RCTPromiseResolveBlock)resolve reject:(RCTPromiseRejectBlock)reject) {
    [[ARKit sharedInstance] resume];
    resolve(@{});
}


RCT_EXPORT_METHOD(
  hitTestPlanes: (NSDictionary *)pointDict
  types:(NSUInteger)types
  resolve:(RCTPromiseResolveBlock)resolve
  reject:(RCTPromiseRejectBlock)reject
  ) {
    CGPoint point = CGPointMake(  [pointDict[@"x"] floatValue], [pointDict[@"y"] floatValue] );
    [[ARKit sharedInstance] hitTestPlane:point types:types resolve:resolve reject:reject];
}

RCT_EXPORT_METHOD(
                  hitTestSceneObjects: (NSDictionary *)pointDict
                  resolve:(RCTPromiseResolveBlock)resolve
                  reject:(RCTPromiseRejectBlock)reject
                  ) {
    CGPoint point = CGPointMake(  [pointDict[@"x"] floatValue], [pointDict[@"y"] floatValue] );
    [[ARKit sharedInstance] hitTestSceneObjects:point resolve:resolve reject:reject];
}




RCT_EXPORT_METHOD(snapshot:(RCTPromiseResolveBlock)resolve reject:(RCTPromiseRejectBlock)reject) {
    [[ARKit sharedInstance] snapshot:resolve reject:reject];
}

RCT_EXPORT_METHOD(snapshotCamera:(RCTPromiseResolveBlock)resolve reject:(RCTPromiseRejectBlock)reject) {
    [[ARKit sharedInstance] snapshotCamera:resolve reject:reject];
}

RCT_EXPORT_METHOD(getCameraPosition:(RCTPromiseResolveBlock)resolve reject:(RCTPromiseRejectBlock)reject) {
    resolve([[ARKit sharedInstance] readCameraPosition]);
}

RCT_EXPORT_METHOD(focusScene:(RCTPromiseResolveBlock)resolve reject:(RCTPromiseRejectBlock)reject) {
    [[ARKit sharedInstance] focusScene];
    resolve(@{});
}

@end
