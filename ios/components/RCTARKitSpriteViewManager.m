#import "RCTARKitSpriteViewManager.h"
#import "RCTARKitSpriteView.h"
#import <React/RCTUIManager.h>
#import <React/RCTBridgeModule.h>
#import "RCTARKit.h"

@implementation RCTARKitSpriteViewManager

RCT_EXPORT_MODULE();

@synthesize bridge = _bridge;

RCT_EXPORT_VIEW_PROPERTY(position3D, SCNVector3)
RCT_EXPORT_VIEW_PROPERTY(transitionDuration, float)

- (UIView *)view
{
    UIView * view =  [[RCTARKitSpriteView alloc] init];
    
    return view;
}


RCT_EXPORT_METHOD(startAnimation:(nonnull NSNumber *)reactTag)
{
    [self.bridge.uiManager addUIBlock:^(__unused RCTUIManager *uiManager, NSDictionary<NSNumber *, RCTARKitSpriteView *> *viewRegistry) {
        RCTARKitSpriteView *view = viewRegistry[reactTag];
        if ([view isKindOfClass:[RCTARKitSpriteView class]]) {
              [[ARKit sharedInstance] addRendererDelegates:view];
        }
    }];
}

RCT_EXPORT_METHOD(stopAnimation:(nonnull NSNumber *)reactTag)
{
    [self.bridge.uiManager addUIBlock:^(__unused RCTUIManager *uiManager, NSDictionary<NSNumber *, RCTARKitSpriteView *> *viewRegistry) {
        RCTARKitSpriteView *view = viewRegistry[reactTag];
        if ([view isKindOfClass:[RCTARKitSpriteView class]]) {
            [[ARKit sharedInstance] removeRendererDelegates:view];
        }
    }];
}



@end
