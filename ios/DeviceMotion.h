//
//  DeviceMotion.h
//  RCTARKit
//
//  Created by Zehao Li on 7/29/17.
//  Copyright © 2017 HippoAR. All rights reserved.
//

#import <CoreMotion/CoreMotion.h>
#import <React/RCTBridgeModule.h>
#import <React/RCTEventEmitter.h>

@interface DeviceMotion : RCTEventEmitter <RCTBridgeModule>

@property (nonatomic) CMMotionManager *motionManager;

- (void)setUpdateInterval:(double) interval;
- (void)getUpdateInterval:(RCTResponseSenderBlock) cb;
- (void)getData:(RCTResponseSenderBlock) cb;
- (void)startUpdates;
- (void)stopUpdates;

@end
