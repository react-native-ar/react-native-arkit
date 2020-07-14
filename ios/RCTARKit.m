//
//  RCTARKit.m
//  RCTARKit
//
//  Created by HippoAR on 7/9/17.
//  Copyright © 2017 HippoAR. All rights reserved.
//

#import "RCTARKit.h"
#import "RCTConvert+ARKit.h"
#import "RCTMultiPeer.h"

@import CoreLocation;

@interface RCTARKit () <ARSCNViewDelegate, ARSessionDelegate, UIGestureRecognizerDelegate, MultipeerConnectivityDelegate> {
    RCTARKitResolve _resolve;
}

@property (nonatomic, strong) ARSession* session;
@property (nonatomic, strong) ARWorldTrackingConfiguration *configuration;
@property (nonatomic, strong) ARWorldMap *worldMap;

@end


void dispatch_once_on_main_thread(dispatch_once_t *predicate,
                                  dispatch_block_t block) {
    if ([NSThread isMainThread]) {
        dispatch_once(predicate, block);
    } else {
        if (DISPATCH_EXPECT(*predicate == 0L, NO)) {
            dispatch_sync(dispatch_get_main_queue(), ^{
                dispatch_once(predicate, block);
            });
        }
    }
}


@implementation RCTARKit
static RCTARKit *instance = nil;

+ (bool)isInitialized {
    return instance !=nil;
}

+ (instancetype)sharedInstance {
    
    static dispatch_once_t onceToken;
    
    dispatch_once_on_main_thread(&onceToken, ^{
        if (instance == nil) {
            ARSCNView *arView = [[ARSCNView alloc] init];
            MultipeerConnectivity *multipeer = [[MultipeerConnectivity alloc] init];
            instance = [[self alloc] initWithARView:arView];
            multipeer.delegate = instance;
            instance.multipeer = multipeer;
        }
    });
    
    return instance;
}

- (bool)isMounted {
    return self.superview != nil;
}

- (instancetype)initWithARView:(ARSCNView *)arView {
    if ((self = [super init])) {
        self.arView = arView;
        
        // delegates
        arView.delegate = self;
        arView.session.delegate = self;
        
        UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapFrom:)];
        tapGestureRecognizer.numberOfTapsRequired = 1;
        [self.arView addGestureRecognizer:tapGestureRecognizer];
        
        UIRotationGestureRecognizer *rotationGestureRecognizer = [[UIRotationGestureRecognizer alloc] initWithTarget:self action:@selector(handleRotationFrom:)];
        [self.arView addGestureRecognizer:rotationGestureRecognizer];

        UIPinchGestureRecognizer *pinchGestureRecognizer = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(handlePinchFrom:)];
        [self.arView addGestureRecognizer:pinchGestureRecognizer];

        self.touchDelegates = [NSMutableArray array];
        self.rendererDelegates = [NSMutableArray array];
        self.sessionDelegates = [NSMutableArray array];
        
        // nodeManager
        self.nodeManager = [RCTARKitNodes sharedInstance];
        self.nodeManager.arView = arView;
        [self.sessionDelegates addObject:self.nodeManager];
        
        // configuration(s)
        arView.autoenablesDefaultLighting = YES;
        arView.scene.rootNode.name = @"root";
        
        #if TARGET_IPHONE_SIMULATOR
        // allow for basic orbit gestures if we're running in the simulator
        arView.allowsCameraControl = YES;
        arView.defaultCameraController.interactionMode = SCNInteractionModeOrbitTurntable;
        arView.defaultCameraController.maximumVerticalAngle = 45;
        arView.defaultCameraController.inertiaEnabled = YES;
        [arView.defaultCameraController translateInCameraSpaceByX:(float) 0.0 Y:(float) 0.0 Z:(float) 3.0];
        
        #endif
        // start ARKit
        [self addSubview:arView];
        [self resume];
    }
    return self;
}

- (void)receivedDataHandler:(NSData *)data PeerID:(MCPeerID *)peerID
{
    id parsedJSON;
    @try {
        NSError *error = nil;
        parsedJSON = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
    } @catch (NSException *exception) {
        // TODO: make a onMultipeerDataFailure callback
    } @finally {
        
    }
    
    if (parsedJSON) {
        if (self.onMultipeerJsonDataReceived) {
            dispatch_async(dispatch_get_main_queue(), ^{
                self.onMultipeerJsonDataReceived(@{
                                       @"data": parsedJSON,
                                       });
            });
        }
    } else {
            id unarchived = [NSKeyedUnarchiver unarchivedObjectOfClass:[ARWorldMap classForKeyedUnarchiver] fromData:data error:nil];
            
            if ([unarchived isKindOfClass:[ARWorldMap class]]) {
                NSLog(@"[unarchived class]====%@",[unarchived class]);
                ARWorldMap *worldMap = unarchived;
                self.configuration = [[ARWorldTrackingConfiguration alloc] init];
                self.configuration.worldAlignment = ARWorldAlignmentGravity;
                self.configuration.planeDetection = ARPlaneDetectionHorizontal|ARPlaneDetectionVertical;
                self.configuration.initialWorldMap = worldMap;
                [self.arView.session runWithConfiguration:self.configuration options:ARSessionRunOptionResetTracking|ARSessionRunOptionRemoveExistingAnchors];
                
                return;
            }
            
            unarchived = [NSKeyedUnarchiver unarchivedObjectOfClass:[ARAnchor classForKeyedUnarchiver] fromData:data error:nil];
            
            if ([unarchived isKindOfClass:[ARAnchor class]]) {
                NSLog(@"[unarchived class]====%@",[unarchived class]);
                ARAnchor *anchor = unarchived;
                
                [self.arView.session addAnchor:anchor];
                
                return;
            }
            
            NSLog(@"unknown data recieved from \(%@)",peerID.displayName);
    }
}


- (void)layoutSubviews {
    [super layoutSubviews];
    //NSLog(@"setting view bounds %@", NSStringFromCGRect(self.bounds));
    self.arView.frame = self.bounds;
}

- (void)pause {
    [self.session pause];
}

- (void)resume {
    [self.session runWithConfiguration:self.configuration];
}

- (void)session:(ARSession *)session didFailWithError:(NSError *)error {
    if(self.onARKitError) {
        self.onARKitError(RCTJSErrorFromNSError(error));
    } else {
        NSLog(@"Initializing ARKIT failed with Error: %@ %@", error, [error userInfo]);
        
    }
    
}

- (void)getCurrentWorldMap:(RCTARKitResolve)resolve reject:(RCTARKitReject)reject {
    [self.arView.session getCurrentWorldMapWithCompletionHandler:^(ARWorldMap * _Nullable worldMap, NSError * _Nullable error) {
        NSLog(@"got the current world map!!!");
        if (error) {
            NSLog(@"error====%@",error);
        }

        NSData *data = [NSKeyedArchiver archivedDataWithRootObject:worldMap requiringSecureCoding:true error:nil];
        [[ARKit sharedInstance].multipeer sendToAllPeers:data];
    }];
}

- (void)reset {
    if (ARWorldTrackingConfiguration.isSupported) {
        [self.session runWithConfiguration:self.configuration options:ARSessionRunOptionRemoveExistingAnchors | ARSessionRunOptionResetTracking];
    }
}

- (void)focusScene {
    [self.nodeManager.localOrigin setPosition:self.nodeManager.cameraOrigin.position];
    [self.nodeManager.localOrigin setRotation:self.nodeManager.cameraOrigin.rotation];
}

- (void)clearScene {
    [self.nodeManager clear];
}


#pragma mark - setter-getter

- (ARSession*)session {
    return self.arView.session;
}

- (BOOL)debug {
    return self.arView.showsStatistics;
}

- (void)setDebug:(BOOL)debug {
    if (debug) {
        self.arView.showsStatistics = YES;
        self.arView.debugOptions = ARSCNDebugOptionShowFeaturePoints;
    } else {
        self.arView.showsStatistics = NO;
        self.arView.debugOptions = SCNDebugOptionNone;
    }
}

- (ARPlaneDetection)planeDetection {
    ARWorldTrackingConfiguration *configuration = (ARWorldTrackingConfiguration *) self.configuration;
    return configuration.planeDetection;
}

- (void)setPlaneDetection:(ARPlaneDetection)planeDetection {
    ARWorldTrackingConfiguration *configuration = (ARWorldTrackingConfiguration *) self.configuration;
   
    configuration.planeDetection = planeDetection;
    [self resume];
}

-(NSDictionary*)origin {
    return @{
             @"position": vectorToJson(self.nodeManager.localOrigin.position)
             };
}

-(void)setOrigin:(NSDictionary*)json {
    
    if(json[@"transition"]) {
        NSDictionary * transition =json[@"transition"];
        if(transition[@"duration"]) {
            [SCNTransaction setAnimationDuration:[transition[@"duration"] floatValue]];
        } else {
            [SCNTransaction setAnimationDuration:0.0];
        }
        
    } else {
        [SCNTransaction setAnimationDuration:0.0];
    }
    SCNVector3 position = [RCTConvert SCNVector3:json[@"position"]];
    [self.nodeManager.localOrigin setPosition:position];
}

- (BOOL)lightEstimationEnabled {
    ARConfiguration *configuration = self.configuration;
    return configuration.lightEstimationEnabled;
}


- (void)setLightEstimationEnabled:(BOOL)lightEstimationEnabled {
    ARConfiguration *configuration = self.configuration;
    configuration.lightEstimationEnabled = lightEstimationEnabled;
    [self resume];
}
- (void)setAutoenablesDefaultLighting:(BOOL)autoenablesDefaultLighting {
    self.arView.autoenablesDefaultLighting = autoenablesDefaultLighting;
}

- (BOOL)autoenablesDefaultLighting {
    return self.arView.autoenablesDefaultLighting;
}

- (ARWorldAlignment)worldAlignment {
    ARConfiguration *configuration = self.configuration;
    return configuration.worldAlignment;
}

- (void)setWorldAlignment:(ARWorldAlignment)worldAlignment {
    ARConfiguration *configuration = self.configuration;
    if (worldAlignment == ARWorldAlignmentGravityAndHeading) {
        configuration.worldAlignment = ARWorldAlignmentGravityAndHeading;
    } else if (worldAlignment == ARWorldAlignmentCamera) {
        configuration.worldAlignment = ARWorldAlignmentCamera;
    } else {
        configuration.worldAlignment = ARWorldAlignmentGravity;
    }
    [self resume];
}

#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 110300
- (void)setDetectionImages:(NSArray*) detectionImages {
        if (@available(iOS 11.3, *)) {
            ARWorldTrackingConfiguration *configuration = self.configuration;
            NSSet *detectionImagesSet = [[NSSet alloc] init];
            for (id config in detectionImages) {

                for (id url in config[@"arDetectionImages"]) {
                    NSData * imageData = [[NSData alloc] initWithContentsOfURL: [NSURL URLWithString: url]];

                    UIImage* uiimage = [[UIImage alloc] initWithData:imageData];

                    CGImageRef cgImage = [uiimage CGImage];

                    ARReferenceImage *image = [[ARReferenceImage alloc] initWithCGImage:cgImage orientation:kCGImagePropertyOrientationUp physicalWidth:1];
                    image.name=url;
                    detectionImagesSet = [detectionImagesSet setByAddingObject:image];

                }
            

                if(config[@"resourceGroupName"]) {
                    detectionImagesSet = [detectionImagesSet setByAddingObjectsFromSet:[ARReferenceImage referenceImagesInGroupNamed:config[@"resourceGroupName"] bundle:nil]];
                }
            
            configuration.detectionImages = detectionImagesSet;
            [self resume];
        }
    }
}

#endif
- (NSDictionary *)readCameraPosition {
    // deprecated
    SCNVector3 cameraPosition = self.nodeManager.cameraOrigin.position;
    return vectorToJson(cameraPosition);
}

- (double)radiansFromDegrees:(float)degrees
{
    return degrees * (M_PI/180.0);    
}

- (double)degreesFromRadians:(float)radians
{
    return radians * (180.0/M_PI);
}

- (NSDictionary *)coordinateFromCoord:(float)locationLat locationLong:(float)locationLong atDistanceKm:(float)distanceKm atBearingDegrees:(float)bearingDegrees {

    double distanceRadians = distanceKm / 6371.0;
      //6,371 = Earth's radius in km
    double bearingRadians = [self radiansFromDegrees:bearingDegrees];
    double fromLatRadians = [self radiansFromDegrees:locationLat];
    double fromLonRadians = [self radiansFromDegrees:locationLong];

    double toLatRadians = asin( sin(fromLatRadians) * cos(distanceRadians) 
        + cos(fromLatRadians) * sin(distanceRadians) * cos(bearingRadians) );

    double toLonRadians = fromLonRadians + atan2(sin(bearingRadians) 
        * sin(distanceRadians) * cos(fromLatRadians), cos(distanceRadians) 
        - sin(fromLatRadians) * sin(toLatRadians));

    // adjust toLonRadians to be in the range -180 to +180...
    toLonRadians = fmod((toLonRadians + 3*M_PI), (2*M_PI)) - M_PI;

    CLLocationCoordinate2D result;
    result.latitude = [self degreesFromRadians:toLatRadians];
    result.longitude = [self degreesFromRadians:toLonRadians];
    return  @{
            @"results": @{ @"latitude": @(result.latitude), @"longitude": @(result.longitude) }
        };
}

- (void)getArAnchorPosition:(CLLocation *)location landmark:(CLLocation *)landmark anchorName:(NSString  *)anchorName {

    CLLocationDistance distance = [location distanceFromLocation:landmark];

    matrix_float4x4 distanceTransform = translatingIdentity(0, 0, -distance);

    float rotation = angleBetweenPoints(location, landmark);
    NSLog(@"rotation:-%f", rotation);

    float  tilt = angleOffHorizon(location, landmark);

    simd_float4x4 tiltedTransformation = rotateVertically(distanceTransform, tilt);

    simd_float4x4 completedTransformation = rotateHorizontally(tiltedTransformation, -rotation);

    ARAnchor *localAnchor = [[ARAnchor alloc] initWithName:anchorName transform:completedTransformation];

    [self.arView.session addAnchor:localAnchor];

    return;
}

static SCNVector3 toSCNVector3(simd_float4 float4) {
    SCNVector3 positionAbsolute = SCNVector3Make(float4.x, float4.y, float4.z);
    return positionAbsolute;
}


static float angleBetweenPoints(const CLLocation *location, const CLLocation *landmark) {
    float startLat = GLKMathDegreesToRadians(location.coordinate.latitude);
    float startLon = GLKMathDegreesToRadians(location.coordinate.longitude);
    float endLat = GLKMathDegreesToRadians(landmark.coordinate.latitude);
    float endLon = GLKMathDegreesToRadians(landmark.coordinate.longitude);

    float lonDiff = endLon - startLon;
    float y = sin(lonDiff) * cos(endLat);
    float x = (cos(startLat) * sin(endLat)) - (sin(startLat) * cos(endLat) * cos(lonDiff));
    float angle = atan2(y, x);
    if(angle < 0){
        float finalAngle = angle + (M_PI * 2);
        return finalAngle;
    } else {
        return angle;
    }
}

static matrix_float4x4 translatingIdentity(const float x, const float y, const float z) {
    matrix_float4x4 result = matrix_identity_float4x4;
    result.columns[3].x = x;
    result.columns[3].y = y;
    result.columns[3].z = z;
    return result;
}

static float angleOffHorizon(const CLLocation *start, const CLLocation *end) {
    CLLocationDistance adjacent = [start distanceFromLocation:end];
    float opposite = end.altitude - start.altitude;
    return atan2(opposite, adjacent);
}

static matrix_float4x4 rotateVertically(const matrix_float4x4 distanceTrans, const float radians) {
    GLKMatrix4 rotation = GLKMatrix4MakeXRotation(radians);
    return simd_mul(convert(rotation), distanceTrans);
}

static matrix_float4x4 rotateHorizontally(const matrix_float4x4 titledTrans, const float radians) {
    GLKMatrix4 rotation = GLKMatrix4MakeYRotation(radians);
    return simd_mul(convert(rotation), titledTrans);
}

static simd_float4x4 convert(const GLKMatrix4 matrix) {
    return simd_matrix(
        simd_make_float4(matrix.m00, matrix.m01, matrix.m02, matrix.m03),
        simd_make_float4(matrix.m10, matrix.m11, matrix.m12, matrix.m13),
        simd_make_float4(matrix.m20, matrix.m21, matrix.m22, matrix.m23),
        simd_make_float4(matrix.m30, matrix.m31, matrix.m32, matrix.m33)
    );
}


static NSDictionary * vectorToJson(const SCNVector3 v) {
    return @{ @"x": @(v.x), @"y": @(v.y), @"z": @(v.z) };
}
static NSDictionary * vector_float3ToJson(const simd_float3 v) {
    return @{ @"x": @(v.x), @"y": @(v.y), @"z": @(v.z) };
}
static NSDictionary * vector4ToJson(const SCNVector4 v) {
    return @{ @"x": @(v.x), @"y": @(v.y), @"z": @(v.z), @"w": @(v.w) };
}


- (NSDictionary *)readCamera {
    SCNVector3 position = self.nodeManager.cameraOrigin.position;
    SCNVector4 rotation = self.nodeManager.cameraOrigin.rotation;
    SCNVector4 orientation = self.nodeManager.cameraOrigin.orientation;
    SCNVector3 eulerAngles = self.nodeManager.cameraOrigin.eulerAngles;
    SCNVector3 direction = self.nodeManager.cameraDirection;
    return @{
             @"position":vectorToJson(position),
             @"rotation":vector4ToJson(rotation),
             @"orientation":vector4ToJson(orientation),
             @"eulerAngles":vectorToJson(eulerAngles),
             @"direction":vectorToJson(direction),
             };
}

- (SCNVector3)projectPoint:(SCNVector3)point {
    return [self.arView projectPoint:[self.nodeManager getAbsolutePositionToOrigin:point]];
    
}



- (float)getCameraDistanceToPoint:(SCNVector3)point {
    return [self.nodeManager getCameraDistanceToPoint:point];
    
}



#pragma mark - Lazy loads

-(ARWorldTrackingConfiguration *)configuration {
    if (_configuration) {
        return _configuration;
    }
    
    if (!ARWorldTrackingConfiguration.isSupported) {}
    
    _configuration = [ARWorldTrackingConfiguration new];
    _configuration.planeDetection = ARPlaneDetectionHorizontal;
    return _configuration;
}



#pragma mark - snapshot methods

- (void)hitTestSceneObjects:(const CGPoint)tapPoint resolve:(RCTARKitResolve)resolve reject:(RCTARKitReject)reject {
    resolve([self.nodeManager getSceneObjectsHitResult:tapPoint]);
}


- (UIImage *)getSnapshot:(NSDictionary *)selection {
    UIImage *image = [self.arView snapshot];
    
    
    return [self cropImage:image toSelection:selection];
    
}


- (UIImage *)getSnapshotCamera:(NSDictionary *)selection {
    CVPixelBufferRef pixelBuffer = self.arView.session.currentFrame.capturedImage;
    CIImage *ciImage = [CIImage imageWithCVPixelBuffer:pixelBuffer];
    
    CIContext *temporaryContext = [CIContext contextWithOptions:nil];
    CGImageRef videoImage = [temporaryContext
                             createCGImage:ciImage
                             fromRect:CGRectMake(0, 0,
                                                 CVPixelBufferGetWidth(pixelBuffer),
                                                 CVPixelBufferGetHeight(pixelBuffer))];
    
    UIImage *image = [UIImage imageWithCGImage:videoImage scale: 1.0 orientation:UIImageOrientationRight];
    CGImageRelease(videoImage);
    
    UIImage *cropped = [self cropImage:image toSelection:selection];
    return cropped;
    
}



- (UIImage *)cropImage:(UIImage *)imageToCrop toRect:(CGRect)rect
{
    //CGRect CropRect = CGRectMake(rect.origin.x, rect.origin.y, rect.size.width, rect.size.height+15);
    
    CGImageRef imageRef = CGImageCreateWithImageInRect([imageToCrop CGImage], rect);
    UIImage *cropped = [UIImage imageWithCGImage:imageRef];
    CGImageRelease(imageRef);
    
    return cropped;
}

static inline double radians (double degrees) {return degrees * M_PI/180;}
UIImage* rotate(UIImage* src, UIImageOrientation orientation)
{
    UIGraphicsBeginImageContext(src.size);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    [src drawAtPoint:CGPointMake(0, 0)];
    if (orientation == UIImageOrientationRight) {
        CGContextRotateCTM (context, radians(90));
    } else if (orientation == UIImageOrientationLeft) {
        CGContextRotateCTM (context, radians(-90));
    } else if (orientation == UIImageOrientationDown) {
        // NOTHING
    } else if (orientation == UIImageOrientationUp) {
        CGContextRotateCTM (context, radians(90));
    }
    
    
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}
- (UIImage *)cropImage:(UIImage *)imageToCrop toSelection:(NSDictionary *)selection
{
    
    // selection is in view-coordinate system
    // where as the image is a camera picture with arbitary size
    // also, the camera picture is cut of so that it "covers" the self.bounds
    // if selection is nil, crop to the viewport
    
    UIImage * image = rotate(imageToCrop, imageToCrop.imageOrientation);
    
    float arViewWidth = self.bounds.size.width;
    float arViewHeight = self.bounds.size.height;
    float imageWidth = image.size.width;
    float imageHeight = image.size.height;
    
    float arViewRatio = arViewHeight/arViewWidth;
    float imageRatio = imageHeight/imageWidth;
    float imageToArWidth = imageWidth/arViewWidth;
    float imageToArHeight = imageHeight/arViewHeight;
    
    float finalHeight;
    float finalWidth;
    
    
    if (arViewRatio > imageRatio)
    {
        finalHeight = arViewHeight*imageToArHeight;
        finalWidth = arViewHeight*imageToArHeight /arViewRatio;
    }
    else
    {
        finalWidth = arViewWidth*imageToArWidth;
        finalHeight = arViewWidth * imageToArWidth * arViewRatio;
    }
    
    float topOffset = (image.size.height - finalHeight)/2;
    float leftOffset = (image.size.width - finalWidth)/2;
    
    
    float x = leftOffset;
    float y = topOffset;
    float width = finalWidth;
    float height = finalHeight;
    if(selection && selection != [NSNull null]) {
        x = leftOffset+ [selection[@"x"] floatValue]*imageToArWidth;
        y = topOffset+[selection[@"y"] floatValue]*imageToArHeight;
        width = [selection[@"width"] floatValue]*imageToArWidth;
        height = [selection[@"height"] floatValue]*imageToArHeight;
    }
    CGRect rect = CGRectMake(x, y, width, height);
    
    UIImage *cropped = [self cropImage:image toRect:rect];
    return cropped;
}


#pragma mark - plane hit detection

- (void)hitTestPlane:(const CGPoint)tapPoint types:(ARHitTestResultType)types resolve:(RCTARKitResolve)resolve reject:(RCTARKitReject)reject {
    
    resolve([self getPlaneHitResult:tapPoint types:types]);
}



static NSDictionary * getPlaneHitResult(NSMutableArray *resultsMapped, const CGPoint tapPoint) {
    return @{
             @"results": resultsMapped
             };
}


- (NSDictionary *)getPlaneHitResult:(const CGPoint)tapPoint  types:(ARHitTestResultType)types; {
    NSArray<ARHitTestResult *> *results = [self.arView hitTest:tapPoint types:types];
    NSMutableArray * resultsMapped = [self.nodeManager mapHitResults:results];
    NSDictionary *planeHitResult = getPlaneHitResult(resultsMapped, tapPoint);
    return planeHitResult;
}

- (void)handleTapFrom: (UITapGestureRecognizer *)recognizer {
    // Take the screen space tap coordinates and pass them to the hitTest method on the ARSCNView instance
    CGPoint tapPoint = [recognizer locationInView:self.arView];
    //
    if(self.onTapOnPlaneUsingExtent) {
        // Take the screen space tap coordinates and pass them to the hitTest method on the ARSCNView instance
        // NSDictionary * planeHitResult = [self getPlaneHitResult:tapPoint types:ARHitTestResultTypeExistingPlaneUsingExtent];
        // CGPoint point = CGPointMake(  [pointDict[@"x"] floatValue], [pointDict[@"y"] floatValue] );
                NSDictionary *tap = @{
                    @"x": @(tapPoint.x),
                    @"y": @(tapPoint.y)
                };

        self.onTapOnPlaneUsingExtent(tap);
    }
    
    if(self.onTapOnPlaneNoExtent) {
        // Take the screen space tap coordinates    and pass them to the hitTest method on the ARSCNView instance
        NSDictionary * planeHitResult = [self getPlaneHitResult:tapPoint types:ARHitTestResultTypeExistingPlane];
        self.onTapOnPlaneNoExtent(planeHitResult);
    }
}

- (void)handleRotationFrom: (UIRotationGestureRecognizer *)recognizer {
    
    if( recognizer.state == UIGestureRecognizerStateBegan || 
        recognizer.state == UIGestureRecognizerStateChanged || 
        recognizer.state == UIGestureRecognizerStateEnded) {

        if(self.onRotationGesture) {
            NSDictionary *rotationGesture = @{
                    @"rotation": @(recognizer.rotation),
                    @"velocity": @(recognizer.velocity)
                    };

            self.onRotationGesture(rotationGesture);
        }
    }
}


- (void)handlePinchFrom: (UIPinchGestureRecognizer *)recognizer {
    
    if( recognizer.state == UIGestureRecognizerStateBegan || 
        recognizer.state == UIGestureRecognizerStateChanged || 
        recognizer.state == UIGestureRecognizerStateEnded) {

        if(self.onPinchGesture) {
            NSDictionary *pinchGesture = @{
                    @"scale": @(recognizer.scale),
                    @"velocity": @(recognizer.velocity)
                    };

            self.onPinchGesture(pinchGesture);
        }
    }
}



#pragma mark - ARSCNViewDelegate

- (void)renderer:(id<SCNSceneRenderer>)renderer updateAtTime:(NSTimeInterval)time {
    for (id<RCTARKitRendererDelegate> rendererDelegate in self.rendererDelegates) {
        if ([rendererDelegate respondsToSelector:@selector(renderer:updateAtTime:)]) {
            [rendererDelegate renderer:renderer updateAtTime:time];
        }
    }
}



- (void)renderer:(id <SCNSceneRenderer>)renderer didRenderScene:(SCNScene *)scene atTime:(NSTimeInterval)time {
    for (id<RCTARKitRendererDelegate> rendererDelegate in self.rendererDelegates) {
        if ([rendererDelegate respondsToSelector:@selector(renderer:didRenderScene:atTime:)]) {
            [rendererDelegate renderer:renderer didRenderScene:scene atTime:time];
        }
    }
}




- (NSDictionary *)makeAnchorDetectionResult:(SCNNode *)node anchor:(ARAnchor *)anchor {
    NSDictionary* baseProps = @{
                                @"id": anchor.identifier.UUIDString,
                                @"type": @"unkown",
                                @"eulerAngles":vectorToJson(node.eulerAngles),
                                @"position": vectorToJson([self.nodeManager getRelativePositionToOrigin:node.position]),
                                @"positionAbsolute": vectorToJson(node.position),
                                @"name": anchor.name

                                };
    NSMutableDictionary* dict = [NSMutableDictionary dictionaryWithDictionary:baseProps];
    
    if([anchor isKindOfClass:[ARPlaneAnchor class]]) {
        ARPlaneAnchor *planeAnchor = (ARPlaneAnchor *)anchor;
        NSDictionary * planeProperties = [self makePlaneAnchorProperties:planeAnchor];
        [dict addEntriesFromDictionary:planeProperties];
    } else if (@available(iOS 11.3, *)) {
        #if __IPHONE_OS_VERSION_MAX_ALLOWED >= 110300
        if([anchor isKindOfClass:[ARImageAnchor class]]) {
            ARImageAnchor *imageAnchor = (ARImageAnchor *)anchor;
            NSDictionary * imageProperties = [self makeImageAnchorProperties:imageAnchor];
            [dict addEntriesFromDictionary:imageProperties];
        }
        #endif
    } else {
        // Fallback on earlier versions
    }
    return dict;
}


- (NSDictionary *)makePlaneAnchorProperties:(ARPlaneAnchor *)planeAnchor {
    return @{
             @"type": @"plane",
             @"alignment": @(planeAnchor.alignment),
             @"center": vector_float3ToJson(planeAnchor.center),
             @"extent": vector_float3ToJson(planeAnchor.extent)
             };
    
}

#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 110300
- (NSDictionary *)makeImageAnchorProperties:(ARImageAnchor *)imageAnchor  API_AVAILABLE(ios(11.3)){
    return @{
             @"type": @"image",
             @"image": @{
                     @"name": imageAnchor.referenceImage.name
                     }
             
             };
    
}
  #endif

- (void)addRendererDelegates:(id) delegate {
     [self.rendererDelegates addObject:delegate];
    NSLog(@"added, number of renderer delegates %d", [self.rendererDelegates count]);
}

- (void)removeRendererDelegates:(id) delegate {
    [self.rendererDelegates removeObject:delegate];
     NSLog(@"removed, number of renderer delegates %d", [self.rendererDelegates count]);
}
- (void)renderer:(id <SCNSceneRenderer>)renderer willUpdateNode:(SCNNode *)node forAnchor:(ARAnchor *)anchor {
}


- (void)renderer:(id <SCNSceneRenderer>)renderer didAddNode:(SCNNode *)node forAnchor:(ARAnchor *)anchor {
    
    NSDictionary *anchorDict = [self makeAnchorDetectionResult:node anchor:anchor];
    
    if (self.onPlaneDetected && [anchor isKindOfClass:[ARPlaneAnchor class]]) {
        self.onPlaneDetected(anchorDict);
    } else if (self.onAnchorDetected) {
        self.onAnchorDetected(anchorDict);
    }
    
}

- (void)renderer:(id <SCNSceneRenderer>)renderer didUpdateNode:(SCNNode *)node forAnchor:(ARAnchor *)anchor {
    NSDictionary *anchorDict = [self makeAnchorDetectionResult:node anchor:anchor];
    
    if (self.onPlaneUpdated && [anchor isKindOfClass:[ARPlaneAnchor class]]) {
        self.onPlaneUpdated(anchorDict);
    }else if (self.onAnchorUpdated) {
        self.onAnchorUpdated(anchorDict);
    }
    
}

- (void)renderer:(id<SCNSceneRenderer>)renderer didRemoveNode:(SCNNode *)node forAnchor:(ARAnchor *)anchor {
    NSDictionary *anchorDict = [self makeAnchorDetectionResult:node anchor:anchor];
    
    if (self.onPlaneRemoved && [anchor isKindOfClass:[ARPlaneAnchor class]]) {
        self.onPlaneRemoved(anchorDict);
    } else if (self.onAnchorRemoved) {
        self.onAnchorRemoved(anchorDict);
    }
}




#pragma mark - ARSessionDelegate

- (ARFrame * _Nullable)currentFrame {
    return self.arView.session.currentFrame;
}

- (NSDictionary *)getCurrentLightEstimation {
    return [self wrapLightEstimation:[self currentFrame].lightEstimate];
}

- (NSMutableArray *)getCurrentDetectedFeaturePoints {
    NSMutableArray * featurePoints = [NSMutableArray array];
    for (int i = 0; i < [self currentFrame].rawFeaturePoints.count; i++) {
        vector_float3 positionV = [self currentFrame].rawFeaturePoints.points[i];
        SCNVector3 position = [self.nodeManager getRelativePositionToOrigin:SCNVector3Make(positionV[0],positionV[1],positionV[2])];
        NSString * pointId = [NSString stringWithFormat:@"featurepoint_%lld",[self currentFrame].rawFeaturePoints.identifiers[i]];
        
        [featurePoints addObject:@{
                                   @"x": @(position.x),
                                   @"y": @(position.y),
                                   @"z": @(position.z),
                                   @"id":pointId,
                                   }];
        
    }
    return featurePoints;
}

- (void)session:(ARSession *)session didUpdateFrame:(ARFrame *)frame {
    for (id<RCTARKitSessionDelegate> sessionDelegate in self.sessionDelegates) {
        if ([sessionDelegate respondsToSelector:@selector(session:didUpdateFrame:)]) {
            [sessionDelegate session:session didUpdateFrame:frame];
        }
    }
    if (self.onFeaturesDetected) {
        NSArray * featurePoints = [self getCurrentDetectedFeaturePoints];
        dispatch_async(dispatch_get_main_queue(), ^{
            
            
            if(self.onFeaturesDetected) {
                self.onFeaturesDetected(@{
                                          @"featurePoints":featurePoints
                                          });
            }
        });
    }
    
    if (self.lightEstimationEnabled && self.onLightEstimation) {
        /** this is called rapidly and is therefore demanding, better poll it from outside with getCurrentLightEstimation **/
        
        
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if(self.onLightEstimation) {
                NSDictionary *estimate = [self getCurrentLightEstimation];
                self.onLightEstimation(estimate);
            }
        });
        
    }
    
}

- (NSDictionary *)wrapLightEstimation:(ARLightEstimate *)estimate {
    if(!estimate) {
        return nil;
    }
    return @{
             @"ambientColorTemperature":@(estimate.ambientColorTemperature),
             @"ambientIntensity":@(estimate.ambientIntensity),
             };
}



- (void)session:(ARSession *)session cameraDidChangeTrackingState:(ARCamera *)camera {
    if (self.onTrackingState) {
        dispatch_async(dispatch_get_main_queue(), ^{
            self.onTrackingState(@{
                                   @"state": @(camera.trackingState),
                                   @"reason": @(camera.trackingStateReason)
                                   });
        });
    }
}



#pragma mark - RCTARKitTouchDelegate

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    for (id<RCTARKitTouchDelegate> touchDelegate in self.touchDelegates) {
        if ([touchDelegate respondsToSelector:@selector(touches:beganWithEvent:)]) {
            [touchDelegate touches:touches beganWithEvent:event];
        }
    }
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesMoved:touches withEvent:event];
    for (id<RCTARKitTouchDelegate> touchDelegate in self.touchDelegates) {
        if ([touchDelegate respondsToSelector:@selector(touches:movedWithEvent:)]) {
            [touchDelegate touches:touches movedWithEvent:event];
        }
    }
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesEnded:touches withEvent:event];
    for (id<RCTARKitTouchDelegate> touchDelegate in self.touchDelegates) {
        if ([touchDelegate respondsToSelector:@selector(touches:endedWithEvent:)]) {
            [touchDelegate touches:touches endedWithEvent:event];
        }
    }
}

- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesCancelled:touches withEvent:event];
    for (id<RCTARKitTouchDelegate> touchDelegate in self.touchDelegates) {
        if ([touchDelegate respondsToSelector:@selector(touches:cancelledWithEvent:)]) {
            [touchDelegate touches:touches cancelledWithEvent:event];
        }
    }
}



#pragma mark - dealloc
-(void) dealloc {
}

@end
