//
//  RCTARKitSpriteView.m
//  RCTARKit
//
//  Created by Marco Wettstein on 04.03.18.
//  Copyright © 2018 HippoAR. All rights reserved.
//

#import <Foundation/Foundation.h>


#import "RCTARKitSpriteView.h"
#import "RCTConvert+ARKit.h"
#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@implementation RCTARKitSpriteView {

}



- (CGAffineTransform)getTransform {
    SCNVector3 point = [[ARKit sharedInstance] projectPoint:self.position3D];
    CGAffineTransform t = CGAffineTransformMakeTranslation(point.x, point.y);
    return t;
}

- (void)didMoveToSuperview {
    // set it once
    CGAffineTransform t = [self getTransform];
    [self setTransform:t];
}

- (void)renderer:(id<SCNSceneRenderer>)renderer updateAtTime:(NSTimeInterval)time {
    [self performSelectorOnMainThread:@selector(setTransformByProject) withObject:nil waitUntilDone:NO];
    
}

- (void)setTransformByProject {
    CGAffineTransform t = [self getTransform];
    [UIView beginAnimations:nil context:NULL];
    
    [UIView setAnimationDuration:self.transitionDuration];
    [self setTransform:t];
    [UIView commitAnimations];
}

@end
