//
//  RCTARKitDelegate.h
//  RCTARKit
//
//  Created by Zehao Li on 9/7/17.
//  Copyright © 2017 HippoAR. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <SceneKit/SceneKit.h>
#import <ARKit/ARKit.h>

@protocol RCTARKitTouchDelegate <NSObject>
@optional
- (void)touches:(NSSet<UITouch *> *)touches beganWithEvent:(UIEvent *)event;
- (void)touches:(NSSet<UITouch *> *)touches movedWithEvent:(UIEvent *)event;
- (void)touches:(NSSet<UITouch *> *)touches endedWithEvent:(UIEvent *)event;
- (void)touches:(NSSet<UITouch *> *)touches cancelledWithEvent:(UIEvent *)event;
@end



@protocol RCTARKitRendererDelegate <NSObject>
@optional
- (void)renderer:(id<SCNSceneRenderer>)renderer updateAtTime:(NSTimeInterval)time;
- (void)renderer:(id<SCNSceneRenderer>)renderer didRenderScene:(SCNScene *)scene atTime:(NSTimeInterval)time;
@end



@protocol RCTARKitSessionDelegate <NSObject>
@optional
- (void)session:(ARSession *)session didUpdateFrame:(ARFrame *)frame;
- (void)session:(ARSession *)session didAddAnchors:(NSArray<ARAnchor*>*)anchors;
- (void)session:(ARSession *)session didUpdateAnchors:(NSArray<ARAnchor*>*)anchors;
- (void)session:(ARSession *)session didRemoveAnchors:(NSArray<ARAnchor*>*)anchors;
@end
