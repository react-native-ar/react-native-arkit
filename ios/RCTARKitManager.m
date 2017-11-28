//
//  RCTARKitManager.m
//  RCTARKit
//
//  Created by HippoAR on 7/9/17.
//  Copyright © 2017 HippoAR. All rights reserved.
//

#import "RCTARKitManager.h"
#import "RCTARKit.h"
#import "RCTARKitNodes.h"
#import <UIKit/UIKit.h>
#import <Photos/Photos.h>

@implementation RCTARKitManager

RCT_EXPORT_MODULE()

- (UIView *)view {
    return [ARKit sharedInstance];
}

- (NSDictionary *)constantsToExport
{

    return @{
             @"ARHitTestResultType": @{
                     @"FeaturePoint": @(ARHitTestResultTypeFeaturePoint),
                     @"EstimatedHorizontalPlane": @(ARHitTestResultTypeEstimatedHorizontalPlane),
                     @"ExistingPlane": @(ARHitTestResultTypeExistingPlane),
                     @"ExistingPlaneUsingExtent": @(ARHitTestResultTypeExistingPlaneUsingExtent)
                     },
             @"LightingModel": @{
                     @"Constant": SCNLightingModelConstant,
                     @"Blinn": SCNLightingModelBlinn,
                     @"Lambert": SCNLightingModelLambert,
                     @"Phong": SCNLightingModelPhong,
                     @"PhysicallyBased": SCNLightingModelPhysicallyBased
                     },
             @"LightType": @{
                     @"Ambient": SCNLightTypeAmbient,
                     @"Directional": SCNLightTypeDirectional,
                     @"Omni": SCNLightTypeOmni,
                     @"Probe": SCNLightTypeProbe,
                     @"Spot": SCNLightTypeSpot,
                     @"IES": SCNLightTypeIES
                     },
             @"ShadowMode": @{
                     @"Forward": [@(SCNShadowModeForward) stringValue],
                     @"Deferred": [@(SCNShadowModeDeferred) stringValue],
                     @"ModeModulated": [@(SCNShadowModeModulated) stringValue],
                     },
             @"ColorMask": @{
                     @"All": [@(SCNColorMaskAll) stringValue],
                     @"None": [@(SCNColorMaskNone) stringValue],
                     @"Alpha": [@(SCNColorMaskAlpha) stringValue],
                     @"Blue": [@(SCNColorMaskBlue) stringValue],
                     @"Red": [@(SCNColorMaskRed) stringValue],
                     @"Green": [@(SCNColorMaskGreen) stringValue],
                     },

             @"ShaderModifierEntryPoint": @{
                     @"Geometry": SCNShaderModifierEntryPointGeometry,
                     @"Surface": SCNShaderModifierEntryPointSurface,
                     @"LighingModel": SCNShaderModifierEntryPointLightingModel,
                     @"Fragment": SCNShaderModifierEntryPointFragment
                     },
             @"BlendMode": @{
                     @"Alpha": [@(SCNBlendModeAlpha) stringValue],
                     @"Add": [@(SCNBlendModeAdd) stringValue],
                     @"Subtract": [@(SCNBlendModeSubtract) stringValue],
                     @"Multiply": [@(SCNBlendModeMultiply) stringValue],
                     @"Screen": [@(SCNBlendModeScreen) stringValue],
                     @"Replace": [@(SCNBlendModeReplace) stringValue],

                     },
             @"ChamferMode": @{
                     @"Both": [@(SCNChamferModeBoth) stringValue],
                     @"Back": [@(SCNChamferModeBack) stringValue],
                     @"Front": [@(SCNChamferModeBack) stringValue],

                     },
             @"ARWorldAlignment": @{
                     @"Gravity": @(ARWorldAlignmentGravity),
                     @"GravityAndHeading": @(ARWorldAlignmentGravityAndHeading),
                     @"Camera": @(ARWorldAlignmentCamera),
                     },
             @"FillMode": @{
                     @"Fill": [@(SCNFillModeFill) stringValue],
                     @"Lines": [@(SCNFillModeLines) stringValue],
                     }
             };
}

RCT_EXPORT_VIEW_PROPERTY(debug, BOOL)
RCT_EXPORT_VIEW_PROPERTY(planeDetection, BOOL)
RCT_EXPORT_VIEW_PROPERTY(lightEstimationEnabled, BOOL)
RCT_EXPORT_VIEW_PROPERTY(autoenablesDefaultLighting, BOOL)
RCT_EXPORT_VIEW_PROPERTY(worldAlignment, NSInteger)

RCT_EXPORT_VIEW_PROPERTY(onPlaneDetected, RCTBubblingEventBlock)
RCT_EXPORT_VIEW_PROPERTY(onPlaneUpdate, RCTBubblingEventBlock)
RCT_EXPORT_VIEW_PROPERTY(onTrackingState, RCTBubblingEventBlock)
RCT_EXPORT_VIEW_PROPERTY(onFeaturesDetected, RCTBubblingEventBlock)
RCT_EXPORT_VIEW_PROPERTY(onLightEstimation, RCTBubblingEventBlock)
RCT_EXPORT_VIEW_PROPERTY(onTapOnPlaneUsingExtent, RCTBubblingEventBlock)
RCT_EXPORT_VIEW_PROPERTY(onTapOnPlaneNoExtent, RCTBubblingEventBlock)
RCT_EXPORT_VIEW_PROPERTY(onEvent, RCTBubblingEventBlock)

RCT_EXPORT_METHOD(pause:(RCTPromiseResolveBlock)resolve reject:(RCTPromiseRejectBlock)reject) {
    [[ARKit sharedInstance] pause];
    resolve(@{});
}

RCT_EXPORT_METHOD(resume:(RCTPromiseResolveBlock)resolve reject:(RCTPromiseRejectBlock)reject) {
    [[ARKit sharedInstance] resume];
    resolve(@{});
}

RCT_EXPORT_METHOD(reset:(RCTPromiseResolveBlock)resolve reject:(RCTPromiseRejectBlock)reject) {
    [[ARKit sharedInstance] reset];
    resolve(@{});
}


RCT_EXPORT_METHOD(
                  hitTestPlanes: (NSDictionary *)pointDict
                  types:(NSUInteger)types
                  resolve:(RCTPromiseResolveBlock)resolve
                  reject:(RCTPromiseRejectBlock)reject
                  ) {
    CGPoint point = CGPointMake(  [pointDict[@"x"] floatValue], [pointDict[@"y"] floatValue] );
    [[ARKit sharedInstance] hitTestPlane:point types:types resolve:resolve reject:reject];
}

RCT_EXPORT_METHOD(
                  hitTestSceneObjects: (NSDictionary *)pointDict
                  resolve:(RCTPromiseResolveBlock)resolve
                  reject:(RCTPromiseRejectBlock)reject
                  ) {
    CGPoint point = CGPointMake(  [pointDict[@"x"] floatValue], [pointDict[@"y"] floatValue] );
    [[ARKit sharedInstance] hitTestSceneObjects:point resolve:resolve reject:reject];
}




- (NSString *)getAssetUrl:(NSString *)localID {
    // thx https://stackoverflow.com/a/34788748/1463534
    // heck, objective c is such a mess
    NSString *  assetID = [localID stringByReplacingOccurrencesOfString:@"/.*" withString:@"" options:NSRegularExpressionSearch range:NSMakeRange(0, [localID length])];
    NSString * ext = @"JPG";
    NSString * assetURLStr = [NSString stringWithFormat:@"assets-library://asset/asset.%@?id=%@&ext=%@", ext, assetID, ext];
    return assetURLStr;
}

- (void)storeImageInPhotoAlbum:(UIImage *)image reject:(RCTPromiseRejectBlock)reject resolve:(RCTPromiseResolveBlock)resolve {
    __block PHObjectPlaceholder *placeholder;

    [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
        PHAssetChangeRequest* createAssetRequest = [PHAssetChangeRequest creationRequestForAssetFromImage:image];
        placeholder = [createAssetRequest placeholderForCreatedAsset];

    } completionHandler:^(BOOL success, NSError *error) {
        if (success)
        {

            NSString * localID = placeholder.localIdentifier;

            NSString * assetURLStr = [self getAssetUrl:localID];

            resolve(@{@"url": assetURLStr, @"width":@(image.size.width), @"height": @(image.size.height)});
        }
        else
        {
            reject(@"snapshot_error", @"Could not store snapshot", error);
        }
    }];
}


- (void)storeImageInDirectory:(UIImage *)image directory:(NSString *)directory format:(NSString *)format reject:(RCTPromiseRejectBlock)reject resolve:(RCTPromiseResolveBlock)resolve {
    NSData *data;
    if([format isEqualToString:@"jpg"]) {
        data = UIImageJPEGRepresentation(image, 0.9);
    } else if([format isEqualToString:@"png"]) {
        data = UIImagePNGRepresentation(image);
    } else {
        reject(@"snapshot_error", [NSString stringWithFormat:@"unkown file format '%@'", format], nil);
        return;
    }
    NSString *prefixString = @"capture";

    NSString *guid = [[NSProcessInfo processInfo] globallyUniqueString] ;
    NSString *uniqueFileName = [NSString stringWithFormat:@"%@_%@.%@", prefixString, guid, format];

    NSString *filePath = [directory stringByAppendingPathComponent:uniqueFileName]; //Add the file name
    bool success = [data writeToFile:filePath atomically:YES]; //Write the file
    if(success) {
        resolve(@{@"url": filePath, @"width":@(image.size.width), @"height": @(image.size.height)});
    } else {
        // TODO use NSError from writeToFile
        reject(@"snapshot_error",  [NSString stringWithFormat:@"could not save to '%@'", filePath], nil);
    }

}

- (void)storeImage:(UIImage *)image options:(NSDictionary *)options reject:(RCTPromiseRejectBlock)reject resolve:(RCTPromiseResolveBlock)resolve {
    NSString * target = @"cameraRoll";
    NSString * format = @"png";

    if(options[@"target"]) {
        target = options[@"target"];
    }
    if(options[@"format"]) {
        format = options[@"format"];
    }
    if([target isEqualToString:@"cameraRoll"]) {
        // camera roll / photo album
        [self storeImageInPhotoAlbum:image reject:reject resolve:resolve];
    } else {
        NSString * dir;
        if([target isEqualToString:@"cache"]) {
            dir =  [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject];
        } else if([target isEqualToString:@"documents"]) {
            dir =  [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];

        } else {
            dir = target;
        }
        [self storeImageInDirectory:image directory:dir format:format reject:reject resolve:resolve];
    }
}

RCT_EXPORT_METHOD(snapshot:(NSDictionary *)options resolve:(RCTPromiseResolveBlock)resolve reject:(RCTPromiseRejectBlock)reject) {
    UIImage *image = [[ARKit sharedInstance] getSnaphshot];
    [self storeImage:image options:options reject:reject resolve:resolve];
}




RCT_EXPORT_METHOD(snapshotCamera:(NSDictionary *)options resolve:(RCTPromiseResolveBlock)resolve reject:(RCTPromiseRejectBlock)reject) {
    UIImage *image = [[ARKit sharedInstance] getSnaphshotCamera];
    [self storeImage:image options:options reject:reject resolve:resolve];
}

RCT_EXPORT_METHOD(getCamera:(RCTPromiseResolveBlock)resolve reject:(RCTPromiseRejectBlock)reject) {
    resolve([[ARKit sharedInstance] readCamera]);
}

RCT_EXPORT_METHOD(getCameraPosition:(RCTPromiseResolveBlock)resolve reject:(RCTPromiseRejectBlock)reject) {
    resolve([[ARKit sharedInstance] readCameraPosition]);
}

RCT_EXPORT_METHOD(getCurrentLightEstimation:(RCTPromiseResolveBlock)resolve reject:(RCTPromiseRejectBlock)reject) {
    resolve([[ARKit sharedInstance] getCurrentLightEstimation]);
}

RCT_EXPORT_METHOD(getCurrentDetectedFeaturePoints:(RCTPromiseResolveBlock)resolve reject:(RCTPromiseRejectBlock)reject) {
    resolve([[ARKit sharedInstance] getCurrentDetectedFeaturePoints]);
}

RCT_EXPORT_METHOD(projectPoint:
                  (NSDictionary *)pointDict
                  resolve:(RCTPromiseResolveBlock)resolve
                  reject:(RCTPromiseRejectBlock)reject) {
    SCNVector3 point = SCNVector3Make(  [pointDict[@"x"] floatValue], [pointDict[@"y"] floatValue], [pointDict[@"z"] floatValue] );
    SCNVector3 pointProjected = [[ARKit sharedInstance] projectPoint:point];
    float distance = [[ARKit sharedInstance] getCameraDistanceToPoint:point];
    resolve(@{
              @"x": @(pointProjected.x),
              @"y": @(pointProjected.y),
              @"z": @(pointProjected.z),
              @"distance": @(distance)
              });

}

RCT_EXPORT_METHOD(focusScene:(RCTPromiseResolveBlock)resolve reject:(RCTPromiseRejectBlock)reject) {
    [[ARKit sharedInstance] focusScene];
    resolve(@{});
}

RCT_EXPORT_METHOD(clearScene:(RCTPromiseResolveBlock)resolve reject:(RCTPromiseRejectBlock)reject) {
    [[ARKit sharedInstance] clearScene];
    resolve(@{});
}

@end
