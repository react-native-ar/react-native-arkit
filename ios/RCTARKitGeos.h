//
//  RCTARKitGeos.h
//  RCTARKit
//
//  Created by Zehao Li on 9/24/17.
//  Copyright © 2017 HippoAR. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RCTARKitNodes.h"
#import "RCTARKitIO.h"

@interface RCTARKitGeos : NSObject

@property (nonatomic, strong) RCTARKitIO *arkitIO;
@property (nonatomic, strong) RCTARKitNodes *nodeManager;


+ (instancetype)sharedInstance;

#pragma mark - Add a model or a geometry
- (void)addBox:(NSDictionary *)property;
- (void)addSphere:(NSDictionary *)property;
- (void)addCylinder:(NSDictionary *)property;
- (void)addCone:(NSDictionary *)property;
- (void)addPyramid:(NSDictionary *)property;
- (void)addTube:(NSDictionary *)property;
- (void)addTorus:(NSDictionary *)property;
- (void)addCapsule:(NSDictionary *)property;
- (void)addPlane:(NSDictionary *)property;
- (void)addText:(NSDictionary *)property;
- (void)addModel:(NSDictionary *)property;
- (void)addImage:(NSDictionary *)property;

@end
