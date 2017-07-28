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

RCT_EXPORT_METHOD(addBox:(NSDictionary *)object resolve:(RCTPromiseResolveBlock)resolve reject:(RCTPromiseRejectBlock)reject) {
    BoxProperty property;
    property.x = [object[@"x"] floatValue];
    property.y = [object[@"y"] floatValue];
    property.z = [object[@"z"] floatValue];
    property.width = [object[@"width"] floatValue];
    property.height = [object[@"height"] floatValue];
    property.length = [object[@"length"] floatValue];
    property.chamfer = [object[@"chamfer"] floatValue];
    [[RCTARKit sharedInstance] addBox:property];
}

RCT_EXPORT_METHOD(addSphere:(NSDictionary *)object resolve:(RCTPromiseResolveBlock)resolve reject:(RCTPromiseRejectBlock)reject) {
    SphereProperty property;
    property.x = [object[@"x"] floatValue];
    property.y = [object[@"y"] floatValue];
    property.z = [object[@"z"] floatValue];
    property.radius = [object[@"radius"] floatValue];
    [[RCTARKit sharedInstance] addSphere:property];
}

RCT_EXPORT_METHOD(addCylinder:(NSDictionary *)object resolve:(RCTPromiseResolveBlock)resolve reject:(RCTPromiseRejectBlock)reject) {
    CylinderProperty property;
    property.x = [object[@"x"] floatValue];
    property.y = [object[@"y"] floatValue];
    property.z = [object[@"z"] floatValue];
    property.radius = [object[@"radius"] floatValue];
    property.height = [object[@"height"] floatValue];
    [[RCTARKit sharedInstance] addCylinder:property];
}

RCT_EXPORT_METHOD(addCone:(NSDictionary *)object resolve:(RCTPromiseResolveBlock)resolve reject:(RCTPromiseRejectBlock)reject) {
    ConeProperty property;
    property.x = [object[@"x"] floatValue];
    property.y = [object[@"y"] floatValue];
    property.z = [object[@"z"] floatValue];
    property.topR = [object[@"topR"] floatValue];
    property.bottomR = [object[@"bottomR"] floatValue];
    property.height = [object[@"height"] floatValue];
    [[RCTARKit sharedInstance] addCone:property];
}

RCT_EXPORT_METHOD(addPyramid:(NSDictionary *)object resolve:(RCTPromiseResolveBlock)resolve reject:(RCTPromiseRejectBlock)reject) {
    PyramidProperty property;
    property.x = [object[@"x"] floatValue];
    property.y = [object[@"y"] floatValue];
    property.z = [object[@"z"] floatValue];
    property.width = [object[@"width"] floatValue];
    property.length = [object[@"length"] floatValue];
    property.height = [object[@"height"] floatValue];
    [[RCTARKit sharedInstance] addPyramid:property];
}

RCT_EXPORT_METHOD(addTube:(NSDictionary *)object resolve:(RCTPromiseResolveBlock)resolve reject:(RCTPromiseRejectBlock)reject) {
    TubeProperty property;
    property.x = [object[@"x"] floatValue];
    property.y = [object[@"y"] floatValue];
    property.z = [object[@"z"] floatValue];
    property.innerR = [object[@"innerR"] floatValue];
    property.outerR = [object[@"outerR"] floatValue];
    property.height = [object[@"height"] floatValue];
    [[RCTARKit sharedInstance] addTube:property];
}

RCT_EXPORT_METHOD(addTorus:(NSDictionary *)object resolve:(RCTPromiseResolveBlock)resolve reject:(RCTPromiseRejectBlock)reject) {
    TorusProperty property;
    property.x = [object[@"x"] floatValue];
    property.y = [object[@"y"] floatValue];
    property.z = [object[@"z"] floatValue];
    property.ringR = [object[@"ringR"] floatValue];
    property.pipeR = [object[@"pipeR"] floatValue];
    [[RCTARKit sharedInstance] addTorus:property];
}

RCT_EXPORT_METHOD(addCapsule:(NSDictionary *)object resolve:(RCTPromiseResolveBlock)resolve reject:(RCTPromiseRejectBlock)reject) {
    CapsuleProperty property;
    property.x = [object[@"x"] floatValue];
    property.y = [object[@"y"] floatValue];
    property.z = [object[@"z"] floatValue];
    property.capR = [object[@"capR"] floatValue];
    property.height = [object[@"height"] floatValue];
    [[RCTARKit sharedInstance] addCapsule:property];
}

RCT_EXPORT_METHOD(addPlane:(NSDictionary *)object resolve:(RCTPromiseResolveBlock)resolve reject:(RCTPromiseRejectBlock)reject) {
    PlaneProperty property;
    property.x = [object[@"x"] floatValue];
    property.y = [object[@"y"] floatValue];
    property.z = [object[@"z"] floatValue];
    property.width = [object[@"width"] floatValue];
    property.height = [object[@"height"] floatValue];
    [[RCTARKit sharedInstance] addPlane:property];
}

RCT_EXPORT_METHOD(addText:(NSDictionary *)object resolve:(RCTPromiseResolveBlock)resolve reject:(RCTPromiseRejectBlock)reject) {
    TextProperty *property = [[TextProperty alloc] init];
    property.x = [object[@"x"] floatValue];
    property.y = [object[@"y"] floatValue];
    property.z = [object[@"z"] floatValue];
    property.fontSize = [object[@"fontSize"] floatValue];
    property.depth= [object[@"depth"] floatValue];
    property.text = object[@"text"];
    [[RCTARKit sharedInstance] addText:property];
}

@end
