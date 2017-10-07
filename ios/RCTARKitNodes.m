//
//  RCTARKitNodes.m
//  RCTARKit
//
//  Created by Zehao Li on 9/9/17.
//  Copyright © 2017 HippoAR. All rights reserved.
//

#import "RCTARKitNodes.h"
#import "RCTConvert+ARKit.h"

@implementation SCNNode (ReferenceFrame)
@dynamic referenceFrame;
@end

CGFloat focDistance = 0.2f;


@interface RCTARKitNodes () <RCTARKitSessionDelegate>

@property (nonatomic, strong) SCNNode* rootNode;

@property NSMutableDictionary *nodes;

@end



@implementation RCTARKitNodes

+ (instancetype)sharedInstance {
    static RCTARKitNodes *instance = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        if (instance == nil) {
            instance = [[self alloc] init];
        }
    });
    return instance;
}

- (instancetype)init {
    if ((self = [super init])) {
        // local reference frame origin
        self.localOrigin = [[SCNNode alloc] init];
        self.localOrigin.name = @"localOrigin";
        
        // camera reference frame origin
        self.cameraOrigin = [[SCNNode alloc] init];
        self.cameraOrigin.name = @"cameraOrigin";
        
        // front-of-camera frame origin
        self.frontOfCamera = [[SCNNode alloc] init];
        self.frontOfCamera.name = @"frontOfCamera";
        
        // init cahces
        self.nodes = [NSMutableDictionary new];
    }
    return self;
}

- (void)setArView:(ARSCNView *)arView {
    NSLog(@"setArView");
    _arView = arView;
    self.rootNode = arView.scene.rootNode;
    self.rootNode.name = @"root";
    
    [self.rootNode addChildNode:self.localOrigin];
    [self.rootNode addChildNode:self.cameraOrigin];
    [self.rootNode addChildNode:self.frontOfCamera];
}

#pragma mark

/**
 add a node to scene in a reference frame
 */
- (void)addNodeToScene:(SCNNode *)node inReferenceFrame:(NSString *)referenceFrame {
    if (!referenceFrame) {
        referenceFrame = @"Local"; // default to Local frame
    }
    NSString *selectorString = [NSString stringWithFormat:@"addNodeTo%@Frame:", referenceFrame];
    SEL selector = NSSelectorFromString(selectorString);
    if ([self respondsToSelector:selector]) {
        // check https://stackoverflow.com/questions/7017281/performselector-may-cause-a-leak-because-its-selector-is-unknown
        IMP imp = [self methodForSelector:selector];
        void (*func)(id, SEL, SCNNode*) = (void *)imp;
        func(self, selector, node);
    }
}

- (void)clear {
    // clear scene
    NSArray *keys = [self.nodes allKeys];
    
    for (id key in keys) {
        id node = [self.nodes objectForKey:key];
        if (node) {
            [node removeFromParentNode];
        }
        
    }
    [self.nodes removeAllObjects];
}

- (void)addNodeToLocalFrame:(SCNNode *)node {
    node.referenceFrame = RFReferenceFrameLocal;
    
    NSLog(@"[RCTARKitNodes] Add model %@ to Local frame at (%.2f, %.2f, %.2f)", node.name, node.position.x, node.position.y, node.position.z);

    [self registerNode:node forKey:node.name];
    [self.localOrigin addChildNode:node];
}

- (void)addNodeToCameraFrame:(SCNNode *)node {
    node.referenceFrame = RFReferenceFrameCamera;
    
    NSLog(@"[RCTARKitNodes] Add model %@ to Camera frame at (%.2f, %.2f, %.2f)", node.name, node.position.x, node.position.y, node.position.z);
    [self registerNode:node forKey:node.name];
    [self.cameraOrigin addChildNode:node];
}

- (void)addNodeToFrontOfCameraFrame:(SCNNode *)node {
    node.referenceFrame = RFReferenceFrameFrontOfCamera;
    
    NSLog(@"[RCTARKitNodes] Add model %@ to FrontOfCamera frame at (%.2f, %.2f, %.2f)", node.name, node.position.x, node.position.y, node.position.z);
    [self registerNode:node forKey:node.name];
    [self.frontOfCamera addChildNode:node];
}


- (NSDictionary *)getSceneObjectsHitResult:(const CGPoint)tapPoint  {
    NSDictionary *options = @{
                              SCNHitTestRootNodeKey: self.localOrigin
                              };
    NSArray<SCNHitTestResult *> *results = [_arView hitTest:tapPoint  options:options];
    NSMutableArray * resultsMapped = [self mapHitResultsWithSceneResults:results];
    NSDictionary *planeHitResult = getSceneObjectHitResult(resultsMapped, tapPoint);
    return planeHitResult;
}


static NSDictionary * getSceneObjectHitResult(NSMutableArray *resultsMapped, const CGPoint tapPoint) {
    return @{
             @"results": resultsMapped,
             @"tapPoint": @{
                     @"x": @(tapPoint.x),
                     @"y": @(tapPoint.y)
                     }
             };
}


- (NSMutableArray *) mapHitResultsWithSceneResults: (NSArray<SCNHitTestResult *> *)results {
    
    NSMutableArray *resultsMapped = [NSMutableArray arrayWithCapacity:[results count]];
    [results enumerateObjectsUsingBlock:^(id obj, NSUInteger index, BOOL *stop) {
        SCNHitTestResult *result = (SCNHitTestResult *) obj;
        SCNNode * node = result.node;
        NSArray *keys = [self.nodes allKeysForObject: node];
        if([keys count]) {
            
            NSString * firstKey = [keys firstObject];
            [resultsMapped addObject:(@{
                                        @"id": firstKey
                                        } )];
        } else {
            NSLog(@"no key found for node %@", node);
            NSLog(@"for results %@", results);
            NSLog(@"all nodes %@", self.nodes);
            NSLog(@"origin %@", self.localOrigin);
        }
        
    }];
    return resultsMapped;
    
}



#pragma mark - node register
- (void)registerNode:(SCNNode *)node forKey:(NSString *)key {
    [self removeNodeForKey:key];
    if (node) {
        [self.nodes setObject:node forKey:key];
    }
}

- (SCNNode *)nodeForKey:(NSString *)key {
    return [self.nodes objectForKey:key];
}

- (void)removeNodeForKey:(NSString *)key {
    SCNNode *node = [self.nodes objectForKey:key];
    if (node) {
        [node removeFromParentNode];
        [self.nodes removeObjectForKey:key];
    }
}

- (void)updateNode:(NSString *)key properties:(NSDictionary *) properties {
     SCNNode *node = [self.nodes objectForKey:key];
    // only basic properties like position and rotation can currently be updated this way
    if(node) {
        [RCTConvert setNodeProperties:node properties:properties];
    }
    
}


#pragma mark - RCTARKitSessionDelegate
- (void)session:(ARSession *)session didUpdateFrame:(ARFrame *)frame {
    simd_float4 pos = frame.camera.transform.columns[3];
    self.cameraOrigin.position = SCNVector3Make(pos.x, pos.y, pos.z);
    simd_float4 z = frame.camera.transform.columns[2];
    self.cameraDirection = SCNVector3Make(-z.x, -z.y, -z.z);
    self.cameraOrigin.eulerAngles = SCNVector3Make(0, atan2f(z.x, z.z), 0);
    self.frontOfCamera.position = SCNVector3Make(pos.x - focDistance * z.x, pos.y  - focDistance * z.y, pos.z - focDistance * z.z);
    self.frontOfCamera.eulerAngles = self.cameraOrigin.eulerAngles;
}

@end
