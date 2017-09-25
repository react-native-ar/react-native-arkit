//
//  DeviceMotion.m
//  RCTARKit
//
//  Created by Zehao Li on 7/29/17.
//  Copyright © 2017 HippoAR. All rights reserved.
//

#import <React/RCTBridge.h>
#import <React/RCTEventDispatcher.h>
#import "DeviceMotion.h"

@implementation DeviceMotion

@synthesize bridge = _bridge;

RCT_EXPORT_MODULE();

- (id)init {
    self = [super init];
    return self;
}

- (CMMotionManager *)motionManager {
    if (_motionManager) {
        return _motionManager;
    }

    _motionManager = [[CMMotionManager alloc] init];
    if (![_motionManager isDeviceMotionAvailable]) {
        NSLog(@"DeviceMotion not Available!");
        return _motionManager;
    }

    NSLog(@"DeviceMotion available");
    if ([_motionManager isDeviceMotionActive] == NO) {
        NSLog(@"DeviceMotion active");
    } else {
        NSLog(@"DeviceMotion not active");
    }
    return _motionManager;
}

- (NSArray<NSString *> *)supportedEvents {
    return @[@"MotionData"];
}

RCT_EXPORT_METHOD(setUpdateInterval:(double) interval) {
    NSLog(@"setDeviceMotionUpdateInterval: %f", interval);
    [self.motionManager setDeviceMotionUpdateInterval:interval];
}

RCT_EXPORT_METHOD(getUpdateInterval:(RCTResponseSenderBlock) cb) {
    double interval = self.motionManager.deviceMotionUpdateInterval;
    NSLog(@"getDeviceMotionUpdateInterval: %f", interval);
    cb(@[[NSNull null], [NSNumber numberWithDouble:interval]]);
}

RCT_EXPORT_METHOD(getData:(RCTResponseSenderBlock) cb) {
    CMAcceleration gravity = self.motionManager.deviceMotion.gravity;
    CMRotationMatrix m = self.motionManager.deviceMotion.attitude.rotationMatrix;

    cb(@[[NSNull null], @{
             @"gravity": @{ @"x" : @(gravity.x), @"y" : @(gravity.y), @"z" : @(gravity.z) },
             @"rotationMatrix": @{
                     @"m11" : @(m.m11), @"m12" : @(m.m12), @"m13" : @(m.m13),
                     @"m21" : @(m.m21), @"m22" : @(m.m22), @"m23" : @(m.m23),
                     @"m31" : @(m.m31), @"m32" : @(m.m32), @"m33" : @(m.m33) },
             }]);
}

RCT_EXPORT_METHOD(startUpdates) {
    NSLog(@"startDeviceMotionUpdates");
    [self.motionManager startDeviceMotionUpdates];

    /* Receive the DeviceMotion data on this block */
    [self.motionManager startDeviceMotionUpdatesToQueue:[NSOperationQueue mainQueue]
                                            withHandler:^(CMDeviceMotion *deviceMotion, NSError *error) {
                                                CMAcceleration gravity = deviceMotion.gravity;
                                                CMRotationMatrix m = deviceMotion.attitude.rotationMatrix;
                                                [self sendEventWithName:@"MotionData"
                                                                   body:@{
                                                                          @"gravity": @{ @"x" : @(gravity.x), @"y" : @(gravity.y), @"z" : @(gravity.z) },
                                                                          @"rotationMatrix": @{
                                                                                  @"m11" : @(m.m11), @"m12" : @(m.m12), @"m13" : @(m.m13),
                                                                                  @"m21" : @(m.m21), @"m22" : @(m.m22), @"m23" : @(m.m23),
                                                                                  @"m31" : @(m.m31), @"m32" : @(m.m32), @"m33" : @(m.m33) },
                                                                          }];
                                            }];
}

RCT_EXPORT_METHOD(stopUpdates) {
    NSLog(@"stopDeviceMotionUpdates");
    [self.motionManager stopDeviceMotionUpdates];
}

@end
