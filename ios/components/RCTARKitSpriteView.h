//
//  RCTARKitSpriteView.h
//  RCTARKit
//
//  Created by Marco Wettstein on 04.03.18.
//  Copyright © 2018 HippoAR. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RCTARKit.h"
#import <React/RCTView.h>
#import "RCTARKitDelegate.h"

@interface RCTARKitSpriteView : RCTView <RCTARKitRendererDelegate>

@property (nonatomic, assign) SCNVector3 position3D;
@property (nonatomic, assign) float transitionDuration;

@end



