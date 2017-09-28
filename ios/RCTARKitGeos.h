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
- (void)addBox:(NSDictionary *)property material:(SCNMaterial *)material;
- (void)addSphere:(NSDictionary *)property material:(SCNMaterial *)material;
- (void)addCylinder:(NSDictionary *)property material:(SCNMaterial *)material;
- (void)addCone:(NSDictionary *)property material:(SCNMaterial *)material;
- (void)addPyramid:(NSDictionary *)property material:(SCNMaterial *)material;
- (void)addTube:(NSDictionary *)property material:(SCNMaterial *)material;
- (void)addTorus:(NSDictionary *)property material:(SCNMaterial *)material;
- (void)addCapsule:(NSDictionary *)property material:(SCNMaterial *)material;
- (void)addPlane:(NSDictionary *)property material:(SCNMaterial *)material;
- (void)addText:(NSDictionary *)property material:(SCNMaterial *)material;
- (void)addModel:(NSDictionary *)property;
- (void)addImage:(NSDictionary *)property;

@end
