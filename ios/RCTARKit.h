//
//  RCTARKit.h
//  RCTARKit
//
//  Created by HippoAR on 7/9/17.
//  Copyright © 2017 HippoAR. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SceneKit/SceneKit.h>
#import <ARKit/ARKit.h>

@interface RCTARKit : ARSCNView

@property (nonatomic, assign) BOOL debug;
@property (nonatomic, readonly) NSDictionary *cameraPosition;

+ (instancetype)sharedInstance;

@end
