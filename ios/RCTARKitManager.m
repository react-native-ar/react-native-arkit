//
//  RCTARKitManager.m
//  RCTARKit
//
//  Created by HippoAR on 7/9/17.
//  Copyright © 2017 HippoAR. All rights reserved.
//

#import <React/RCTViewManager.h>

#import "RCTARKit.h"

@interface RCTARKitManager : RCTViewManager
@end

@implementation RCTARKitManager

RCT_EXPORT_MODULE()

- (UIView *)view {
    return [RCTARKit new];
}

RCT_EXPORT_VIEW_PROPERTY(debug, BOOL)

@end
