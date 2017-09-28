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

- (void)addText:(NSDictionary *)property material:(SCNMaterial *)material;
- (void)addModel:(NSDictionary *)property;
- (void)addImage:(NSDictionary *)property;

@end
