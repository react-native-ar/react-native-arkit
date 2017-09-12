//
//  RCTARKitManager.m
//  RCTARKit
//
//  Created by HippoAR on 7/9/17.
//  Copyright © 2017 HippoAR. All rights reserved.
//

#import "RCTARKitManager.h"
#import "RCTARKit.h"

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



RCT_EXPORT_METHOD(snapshot:(RCTPromiseResolveBlock)resolve reject:(RCTPromiseRejectBlock)reject) {
    [[ARKit sharedInstance] snapshot:resolve reject:reject];
}

RCT_EXPORT_METHOD(getCameraPosition:(RCTPromiseResolveBlock)resolve reject:(RCTPromiseRejectBlock)reject) {
    resolve([[ARKit sharedInstance] readCameraPosition]);
}


RCT_EXPORT_METHOD(addBox:(NSDictionary *)property) {
    [[ARKit sharedInstance] addBox:property];
}

RCT_EXPORT_METHOD(addSphere:(NSDictionary *)property) {
    [[ARKit sharedInstance] addSphere:property];
}

RCT_EXPORT_METHOD(addCylinder:(NSDictionary *)property) {
    [[ARKit sharedInstance] addCylinder:property];
}

RCT_EXPORT_METHOD(addCone:(NSDictionary *)property) {
    [[ARKit sharedInstance] addCone:property];
}

RCT_EXPORT_METHOD(addPyramid:(NSDictionary *)property) {
    [[ARKit sharedInstance] addPyramid:property];
}

RCT_EXPORT_METHOD(addTube:(NSDictionary *)property) {
    [[ARKit sharedInstance] addTube:property];
}

RCT_EXPORT_METHOD(addTorus:(NSDictionary *)property) {
    [[ARKit sharedInstance] addTorus:property];
}

RCT_EXPORT_METHOD(addCapsule:(NSDictionary *)property) {
    [[ARKit sharedInstance] addCapsule:property];
}

RCT_EXPORT_METHOD(addPlane:(NSDictionary *)property) {
    [[ARKit sharedInstance] addPlane:property];
}

RCT_EXPORT_METHOD(addText:(NSDictionary *)property) {
    [[ARKit sharedInstance] addText:property];
}

RCT_EXPORT_METHOD(addModel:(NSDictionary *)property) {
    [[ARKit sharedInstance] addModel:property];
}

RCT_EXPORT_METHOD(addImage:(NSDictionary *)property) {
    [[ARKit sharedInstance] addImage:property];
}

@end
