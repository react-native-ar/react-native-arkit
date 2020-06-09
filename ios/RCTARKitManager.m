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
#import "color-grabber.h"
#import "RCTMultiPeer.h"

@interface RCTARKitManager () <MCBrowserViewControllerDelegate>

@end
@implementation RCTARKitManager

RCT_EXPORT_MODULE()



- (UIView *)view {
    return [ARKit sharedInstance];
}

+ (BOOL)requiresMainQueueSetup
{
    return YES;
}


- (NSDictionary *)constantsToExport
{
    
    NSMutableDictionary * arHitTestResultType =
    [NSMutableDictionary dictionaryWithDictionary:
     @{
       @"FeaturePoint": @(ARHitTestResultTypeFeaturePoint),
       @"EstimatedHorizontalPlane": @(ARHitTestResultTypeEstimatedHorizontalPlane),
       @"ExistingPlane": @(ARHitTestResultTypeExistingPlane),
       @"ExistingPlaneUsingExtent": @(ARHitTestResultTypeExistingPlaneUsingExtent),
       }];
    NSMutableDictionary * arAnchorAligment =
    [NSMutableDictionary
     dictionaryWithDictionary:@{
                                @"Horizontal": @(ARPlaneAnchorAlignmentHorizontal)
                                }];
    NSMutableDictionary * arPlaneDetection =
    [NSMutableDictionary
     dictionaryWithDictionary:@{
                                @"Horizontal": @(ARPlaneDetectionHorizontal),
                                @"None": @(ARPlaneDetectionNone),
                                }];
    #if __IPHONE_OS_VERSION_MAX_ALLOWED >= 110300
    if (@available(iOS 11.3, *)) {
        [arHitTestResultType
         addEntriesFromDictionary:@{
                                    @"ExistingPlaneUsingGeometry": @(ARHitTestResultTypeExistingPlaneUsingGeometry),
                                    @"EstimatedVerticalPlane": @(ARHitTestResultTypeEstimatedVerticalPlane)
                                    }];
        [arPlaneDetection
         addEntriesFromDictionary:@{
                                    @"Vertical": @(ARPlaneDetectionVertical),
                                     @"HorizontalVertical": @(ARPlaneDetectionHorizontal + ARPlaneDetectionVertical),
                                    }];
        [arAnchorAligment
         addEntriesFromDictionary:@{
                                    @"Vertical": @(ARPlaneAnchorAlignmentVertical)
                                    }];
    }
      #endif
    
    
    
    
    return @{
             @"ARHitTestResultType": arHitTestResultType,
             @"ARPlaneDetection": arPlaneDetection,
             @"ARPlaneAnchorAlignment": arAnchorAligment,
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
             @"TransparencyMode": @{
                     @"Default": [@(SCNTransparencyModeAOne) stringValue],
                     @"RGBZero": [@(SCNTransparencyModeRGBZero) stringValue],
                     @"SingleLayer": [@(SCNTransparencyModeSingleLayer) stringValue],
                     @"DualLayer": [@(SCNTransparencyModeDualLayer) stringValue],
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
                     },
             @"WrapMode": @{
                     @"Clamp": [@(SCNWrapModeClamp) stringValue],
                     @"Repeat": [@(SCNWrapModeRepeat) stringValue],
                     @"Mirror": [@(SCNWrapModeMirror) stringValue],
                     },
             @"Constraint": @{
                     @"None": @"0",
                     @"BillboardAxisAll": [@(SCNBillboardAxisAll) stringValue],
                     @"BillboardAxisX": [@(SCNBillboardAxisX) stringValue],
                     @"BillboardAxisY": [@(SCNBillboardAxisY) stringValue],
                     @"BillboardAxisZ": [@(SCNBillboardAxisZ) stringValue],
                     }
             };
}

RCT_EXPORT_VIEW_PROPERTY(debug, BOOL)
RCT_EXPORT_VIEW_PROPERTY(planeDetection, ARPlaneDetection)
RCT_EXPORT_VIEW_PROPERTY(origin, NSDictionary *)
RCT_EXPORT_VIEW_PROPERTY(lightEstimationEnabled, BOOL)
RCT_EXPORT_VIEW_PROPERTY(autoenablesDefaultLighting, BOOL)
RCT_EXPORT_VIEW_PROPERTY(worldAlignment, NSInteger)
RCT_EXPORT_VIEW_PROPERTY(detectionImages, NSArray *)

RCT_EXPORT_VIEW_PROPERTY(onPlaneDetected, RCTBubblingEventBlock)
RCT_EXPORT_VIEW_PROPERTY(onPlaneUpdated, RCTBubblingEventBlock)
RCT_EXPORT_VIEW_PROPERTY(onPlaneRemoved, RCTBubblingEventBlock)

RCT_EXPORT_VIEW_PROPERTY(onAnchorDetected, RCTBubblingEventBlock)
RCT_EXPORT_VIEW_PROPERTY(onAnchorUpdated, RCTBubblingEventBlock)
RCT_EXPORT_VIEW_PROPERTY(onAnchorRemoved, RCTBubblingEventBlock)

RCT_EXPORT_VIEW_PROPERTY(onMultipeerJsonDataReceived, RCTBubblingEventBlock)

// TODO: Option to lock these three below down for host only
RCT_EXPORT_VIEW_PROPERTY(onPeerConnected, RCTBubblingEventBlock)
RCT_EXPORT_VIEW_PROPERTY(onPeerConnecting, RCTBubblingEventBlock)
RCT_EXPORT_VIEW_PROPERTY(onPeerDisconnected, RCTBubblingEventBlock)

RCT_EXPORT_VIEW_PROPERTY(onTrackingState, RCTBubblingEventBlock)
RCT_EXPORT_VIEW_PROPERTY(onFeaturesDetected, RCTBubblingEventBlock)
RCT_EXPORT_VIEW_PROPERTY(onLightEstimation, RCTBubblingEventBlock)
RCT_EXPORT_VIEW_PROPERTY(onTapOnPlaneUsingExtent, RCTBubblingEventBlock)
RCT_EXPORT_VIEW_PROPERTY(onTapOnPlaneNoExtent, RCTBubblingEventBlock)
RCT_EXPORT_VIEW_PROPERTY(onRotationGesture, RCTBubblingEventBlock)
RCT_EXPORT_VIEW_PROPERTY(onPinchGesture, RCTBubblingEventBlock)
RCT_EXPORT_VIEW_PROPERTY(onEvent, RCTBubblingEventBlock)
RCT_EXPORT_VIEW_PROPERTY(onARKitError, RCTBubblingEventBlock)
RCT_EXPORT_VIEW_PROPERTY(worldMap, NSObject);

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

RCT_EXPORT_METHOD(isInitialized:(RCTPromiseResolveBlock)resolve reject:(RCTPromiseRejectBlock)reject) {
    resolve(@([ARKit isInitialized]));
}

RCT_EXPORT_METHOD(openMultipeerBrowser:(NSString *)serviceType resolve:(RCTPromiseResolveBlock)resolve reject:(RCTPromiseRejectBlock)reject) {
    [[ARKit sharedInstance].multipeer openMultipeerBrowser:serviceType];
}

RCT_EXPORT_METHOD(startBrowsingForPeers:(NSString *)serviceType resolve:(RCTPromiseResolveBlock)resolve reject:(RCTPromiseRejectBlock)reject) {
    [[ARKit sharedInstance].multipeer startBrowsingForPeers:serviceType];
}

RCT_EXPORT_METHOD(getFrontOfCameraPosition:resolve:(RCTPromiseResolveBlock)resolve reject:(RCTPromiseRejectBlock)reject) {
    resolve(@{@"frontOfCamera": [ARKit sharedInstance].nodeManager.frontOfCamera});
}

RCT_EXPORT_METHOD(getFrontOfCamera:(RCTPromiseResolveBlock)resolve reject:(RCTPromiseRejectBlock)reject) {
    resolve(@{
              @"x": @([ARKit sharedInstance].nodeManager.frontOfCamera.position.x),
              @"y": @([ARKit sharedInstance].nodeManager.frontOfCamera.position.y),
              @"z": @([ARKit sharedInstance].nodeManager.frontOfCamera.position.z)
              });
}

RCT_EXPORT_METHOD(advertiseReadyToJoinSession:(NSString *)serviceType resolve:(RCTPromiseResolveBlock)resolve reject:(RCTPromiseRejectBlock)reject) {
    [[ARKit sharedInstance].multipeer advertiseReadyToJoinSession:serviceType];
}

// TODO: Should be optionally to only be available to host
RCT_EXPORT_METHOD(sendDataToAllPeers:(NSDictionary *)data resolve:(RCTPromiseResolveBlock)resolve reject:(RCTPromiseRejectBlock)reject) {
    [self sendDataToAll:data callback:resolve];
}

// TODO: Should be optional to lock it down so peers can only send to host
RCT_EXPORT_METHOD(sendDataToPeer:(NSDictionary *)data recipientId:(NSString *)recipientId resolve:(RCTPromiseResolveBlock)resolve reject:(RCTPromiseRejectBlock)reject) {
    [self sendData:recipientId data:data callback:resolve];
}

// TODO: Should be optional to only be available to host
RCT_EXPORT_METHOD(sendWorldmapData:(RCTPromiseResolveBlock)resolve reject:(RCTPromiseRejectBlock)reject) {
    [[ARKit sharedInstance] getCurrentWorldMap:resolve reject:reject];
}

// TODO: Should be optional to only be available to host
RCT_EXPORT_METHOD(getAllConnectedPeers:(RCTPromiseResolveBlock)resolve reject:(RCTPromiseRejectBlock)reject) {
    //TODO: get all peer ids
}

RCT_EXPORT_METHOD(isMounted:(RCTPromiseResolveBlock)resolve reject:(RCTPromiseRejectBlock)reject) {
    if( [ARKit isInitialized]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            resolve(@([[ARKit sharedInstance] isMounted]));
        });
    } else {
        resolve(@(NO));
    }
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

- (void)sendDataToAll:(NSDictionary *)data callback:(RCTResponseSenderBlock)callback {
        NSError *error = nil;
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:data options:0 error:&error];
        [[ARKit sharedInstance].multipeer.session sendData:jsonData toPeers:[RCTARKit sharedInstance].multipeer.session.connectedPeers withMode:MCSessionSendDataReliable error:&error];
    NSLog(@"Sending data...");
        if (error == nil) {
            callback(@[[NSNull null]]);
        }
        else {
            callback(@[[error description]]);
        }
}

- (void)sendData:(NSString *)recipient data:(NSDictionary *)data callback:(RCTResponseSenderBlock)callback {
        NSError *error = nil;
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"peerUUID == %@", recipient];
        NSArray *recipients = [[RCTARKit sharedInstance].multipeer.session.connectedPeers filteredArrayUsingPredicate:predicate];
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:data options:0 error:&error];
        [[ARKit sharedInstance].multipeer.session sendData:jsonData toPeers:recipients withMode:MCSessionSendDataReliable error:&error];
    NSLog(@"Sending data...");
        if (error == nil) {
            callback(@[[NSNull null]]);
        }
        else {
            callback(@[[error description]]);
        }
}




- (NSString *)getAssetUrl:(NSString *)localID {
    // thx https://stackoverflow.com/a/34788748/1463534
    // heck, objective c is such a mess
    NSString *  assetID = [localID stringByReplacingOccurrencesOfString:@"/.*" withString:@"" options:NSRegularExpressionSearch range:NSMakeRange(0, [localID length])];
    NSString * ext = @"JPG";
    NSString * assetURLStr = [NSString stringWithFormat:@"assets-library://asset/asset.%@?id=%@&ext=%@", ext, assetID, ext];
    return assetURLStr;
}

- (void)storeImageInPhotoAlbum:(UIImage *)image cameraProperties:(NSDictionary *) cameraProperties  reject:(RCTPromiseRejectBlock)reject resolve:(RCTPromiseResolveBlock)resolve {
    __block PHObjectPlaceholder *placeholder;
    
    [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
        PHAssetChangeRequest* createAssetRequest = [PHAssetChangeRequest creationRequestForAssetFromImage:image];
        placeholder = [createAssetRequest placeholderForCreatedAsset];
        
    } completionHandler:^(BOOL success, NSError *error) {
        if (success)
        {
            
            NSString * localID = placeholder.localIdentifier;
            
            NSString * assetURLStr = [self getAssetUrl:localID];
            
            resolve(@{@"url": assetURLStr, @"width":@(image.size.width), @"height": @(image.size.height),  @"camera":cameraProperties});
        }
        else
        {
            reject(@"snapshot_error", @"Could not store snapshot", error);
        }
    }];
}


- (void)storeImageInDirectory:(UIImage *)image directory:(NSString *)directory format:(NSString *)format cameraProperties:(NSDictionary *) cameraProperties  reject:(RCTPromiseRejectBlock)reject resolve:(RCTPromiseResolveBlock)resolve {
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
        resolve(@{@"url": filePath, @"width":@(image.size.width), @"height": @(image.size.height),  @"camera":cameraProperties});
    } else {
        // TODO use NSError from writeToFile
        reject(@"snapshot_error",  [NSString stringWithFormat:@"could not save to '%@'", filePath], nil);
    }
    
}

- (void)storeImage:(UIImage *)image options:(NSDictionary *)options reject:(RCTPromiseRejectBlock)reject resolve:(RCTPromiseResolveBlock)resolve cameraProperties:(NSDictionary *)cameraProperties {
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
        [self storeImageInPhotoAlbum:image cameraProperties:cameraProperties reject:reject resolve:resolve ];
    } else {
        NSString * dir;
        if([target isEqualToString:@"cache"]) {
            dir =  [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject];
        } else if([target isEqualToString:@"documents"]) {
            dir =  [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
            
        } else {
            dir = target;
        }
        [self storeImageInDirectory:image directory:dir format:format cameraProperties:cameraProperties reject:reject resolve:resolve ];
    }
}

RCT_EXPORT_METHOD(snapshot:(NSDictionary *)options resolve:(RCTPromiseResolveBlock)resolve reject:(RCTPromiseRejectBlock)reject) {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSDictionary * selection = options[@"selection"];
        NSDictionary * cameraProperties = [[ARKit sharedInstance] readCamera];
        UIImage *image = [[ARKit sharedInstance] getSnapshot:selection];
        
        [self storeImage:image options:options reject:reject resolve:resolve cameraProperties:cameraProperties ];
    });
}




RCT_EXPORT_METHOD(snapshotCamera:(NSDictionary *)options resolve:(RCTPromiseResolveBlock)resolve reject:(RCTPromiseRejectBlock)reject) {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSDictionary * selection = options[@"selection"];
        NSDictionary * cameraProperties = [[ARKit sharedInstance] readCamera];
        UIImage *image = [[ARKit sharedInstance] getSnapshotCamera:selection];
        [self storeImage:image options:options reject:reject resolve:resolve cameraProperties:cameraProperties];
    });
}

RCT_EXPORT_METHOD(pickColorsRaw:(NSDictionary *)options resolve:(RCTPromiseResolveBlock)resolve reject:(RCTPromiseRejectBlock)reject) {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        NSDictionary * selection = options[@"selection"];
        UIImage *image = [[ARKit sharedInstance] getSnapshotCamera:selection];
        resolve([[ColorGrabber sharedInstance] getColorsFromImage:image options:options]);
    });
}

RCT_EXPORT_METHOD(pickColorsRawFromFile:(NSString * )filePath options:(NSDictionary *)options resolve:(RCTPromiseResolveBlock)resolve reject:(RCTPromiseRejectBlock)reject) {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        UIImage *image = [UIImage imageWithContentsOfFile:filePath];
        resolve([[ColorGrabber sharedInstance] getColorsFromImage:image options:options]);
    });
}

RCT_EXPORT_METHOD(getCamera:(RCTPromiseResolveBlock)resolve reject:(RCTPromiseRejectBlock)reject) {
    resolve([[ARKit sharedInstance] readCamera]);
}

RCT_EXPORT_METHOD(getCameraPosition:(RCTPromiseResolveBlock)resolve reject:(RCTPromiseRejectBlock)reject) {
    resolve([[ARKit sharedInstance] readCameraPosition]);
}

RCT_EXPORT_METHOD(getAnchorPosition:(float)locationLat locationLong:(float)locationLong landmarkLat:(float)landmarkLat landmarkLong:(float)landmarkLong resolve:(RCTPromiseResolveBlock)resolve reject:(RCTPromiseRejectBlock)reject) {
    resolve([[ARKit sharedInstance] getArAnchorPosition:locationLat locationLong:locationLong landmarkLat:landmarkLat landmarkLong:landmarkLong]);
}

RCT_EXPORT_METHOD(getNewCoords:(float)locationLat locationLong:(float)locationLong landmarkLat:(float)landmarkLat landmarkLong:(float)landmarkLong resolve:(RCTPromiseResolveBlock)resolve reject:(RCTPromiseRejectBlock)reject) {
    resolve([[ARKit sharedInstance] coordinateFromCoord:locationLat locationLong:locationLong distanceKm:(double)distanceKm atBearingDegrees:(double)bearingDegrees;]);
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

- (void)browserViewControllerDidFinish:(nonnull MCBrowserViewController *)browserViewController {
    dispatch_async(dispatch_get_main_queue(), ^{
        UIViewController *rootViewController = [UIApplication sharedApplication].delegate.window.rootViewController;

        [rootViewController dismissViewControllerAnimated:YES completion:^{
            
        }];
    });
}

- (void)browserViewControllerWasCancelled:(nonnull MCBrowserViewController *)browserViewController {
    dispatch_async(dispatch_get_main_queue(), ^{
        UIViewController *rootViewController = [UIApplication sharedApplication].delegate.window.rootViewController;

        [rootViewController dismissViewControllerAnimated:YES completion:^{
            
        }];
    });
}

@end
