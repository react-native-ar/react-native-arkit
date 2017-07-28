//
//  RCTARKitManager.m
//  RCTARKit
//
//  Created by HippoAR on 7/9/17.
//  Copyright © 2017 HippoAR. All rights reserved.
//

#import "RCTARKitManager.h"
#import "RCTARKit.h"

@interface RCTARKitManager ()
@end

@implementation RCTARKitManager

RCT_EXPORT_MODULE()

- (UIView *)view {
    return [RCTARKit sharedInstance];
}

RCT_EXPORT_VIEW_PROPERTY(debug, BOOL)
RCT_EXPORT_VIEW_PROPERTY(planeDetection, BOOL)
RCT_EXPORT_VIEW_PROPERTY(lightEstimation, BOOL)

RCT_EXPORT_VIEW_PROPERTY(onPlaneDetected, RCTBubblingEventBlock)
RCT_EXPORT_VIEW_PROPERTY(onPlaneUpdate, RCTBubblingEventBlock)
RCT_EXPORT_VIEW_PROPERTY(onTrackingState, RCTBubblingEventBlock)

RCT_EXPORT_METHOD(pause:(RCTPromiseResolveBlock)resolve reject:(RCTPromiseRejectBlock)reject) {
    [[RCTARKit sharedInstance] pause];
    resolve(@{});
}

RCT_EXPORT_METHOD(resume:(RCTPromiseResolveBlock)resolve reject:(RCTPromiseRejectBlock)reject) {
    [[RCTARKit sharedInstance] resume];
    resolve(@{});
}

RCT_EXPORT_METHOD(getCameraPosition:(RCTPromiseResolveBlock)resolve reject:(RCTPromiseRejectBlock)reject) {
    resolve([[RCTARKit sharedInstance] cameraPosition]);
}

RCT_EXPORT_METHOD(snapshot:(RCTPromiseResolveBlock)resolve reject:(RCTPromiseRejectBlock)reject) {
    [[RCTARKit sharedInstance] snapshot:resolve reject:reject];
}

RCT_EXPORT_METHOD(addBox:(NSDictionary *)property) {
    [[RCTARKit sharedInstance] addBox:property];
}

RCT_EXPORT_METHOD(addSphere:(NSDictionary *)property) {
    [[RCTARKit sharedInstance] addSphere:property];
}

RCT_EXPORT_METHOD(addCylinder:(NSDictionary *)property) {
    [[RCTARKit sharedInstance] addCylinder:property];
}

RCT_EXPORT_METHOD(addCone:(NSDictionary *)property) {
    [[RCTARKit sharedInstance] addCone:property];
}

RCT_EXPORT_METHOD(addPyramid:(NSDictionary *)property) {
    [[RCTARKit sharedInstance] addPyramid:property];
}

RCT_EXPORT_METHOD(addTube:(NSDictionary *)property) {
    [[RCTARKit sharedInstance] addTube:property];
}

RCT_EXPORT_METHOD(addTorus:(NSDictionary *)property) {
    [[RCTARKit sharedInstance] addTorus:property];
}

RCT_EXPORT_METHOD(addCapsule:(NSDictionary *)property) {
    [[RCTARKit sharedInstance] addCapsule:property];
}

RCT_EXPORT_METHOD(addPlane:(NSDictionary *)property) {
    [[RCTARKit sharedInstance] addPlane:property];
}

RCT_EXPORT_METHOD(addText:(NSDictionary *)property) {
    [[RCTARKit sharedInstance] addText:property];
}

RCT_EXPORT_METHOD(addModel:(NSDictionary *)property) {
    [[RCTARKit sharedInstance] addModel:property];
}

@end
