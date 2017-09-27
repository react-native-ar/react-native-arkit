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
    [[RCTARKit sharedInstance] resume];
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

RCT_EXPORT_METHOD(projectPoint:
                  (NSDictionary *)pointDict
                  resolve:(RCTPromiseResolveBlock)resolve
                  reject:(RCTPromiseRejectBlock)reject) {
    SCNVector3 point = SCNVector3Make(  [pointDict[@"x"] floatValue], [pointDict[@"y"] floatValue], [pointDict[@"z"] floatValue] );
    SCNVector3 pointProjected = [[ARKit sharedInstance] projectPoint:point];
    resolve(@{ @"x": @(pointProjected.x), @"y": @(pointProjected.y), @"z": @(pointProjected.z) });
    
}

RCT_EXPORT_METHOD(focusScene:(RCTPromiseResolveBlock)resolve reject:(RCTPromiseRejectBlock)reject) {
    [[RCTARKit sharedInstance] focusScene];
    resolve(@{});
}

@end
