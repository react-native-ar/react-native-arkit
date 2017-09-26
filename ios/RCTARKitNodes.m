//
//  RCTARKitNodes.m
//  RCTARKit
//
//  Created by Zehao Li on 9/9/17.
//  Copyright © 2017 HippoAR. All rights reserved.
//

#import "RCTARKitNodes.h"

@implementation SCNNode (ReferenceFrame)
@dynamic referenceFrame;
@end


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
- (void)addNodeToScene:(SCNNode *)node property:(NSDictionary *)property {
    NSString *referenceFrame = property[@"frame"];
    if (!referenceFrame) {
        referenceFrame = @"Local"; // default to Local frame
    }
    NSString *selectorString = [NSString stringWithFormat:@"addNodeTo%@Frame:property:", referenceFrame];
    SEL selector = NSSelectorFromString(selectorString);
    if ([self respondsToSelector:selector]) {
        // check https://stackoverflow.com/questions/7017281/performselector-may-cause-a-leak-because-its-selector-is-unknown
        IMP imp = [self methodForSelector:selector];
        void (*func)(id, SEL, SCNNode*, NSDictionary*) = (void *)imp;
        func(self, selector, node, property);
    }
}

- (void)addNodeToLocalFrame:(SCNNode *)node property:(NSDictionary *)property {
    node.position = [self getPositionFromProperty:property inReferenceFrame:RFReferenceFrameLocal];
    node.eulerAngles = SCNVector3Make(0, [property[@"angle"] floatValue], 0);
    node.referenceFrame = RFReferenceFrameLocal;

    NSString *key = [NSString stringWithFormat:@"%@", property[@"id"]];
    NSLog(@"[RCTARKitNodes] Add model %@ to Local frame at (%.2f, %.2f, %.2f)", key, node.position.x, node.position.y, node.position.z);
    if (key) {
        [self registerNode:node forKey:key];
    }

    [self.localOrigin addChildNode:node];
}

- (void)addNodeToCameraFrame:(SCNNode *)node property:(NSDictionary *)property {
    node.position = [self getPositionFromProperty:property inReferenceFrame:RFReferenceFrameCamera];
    node.eulerAngles = SCNVector3Make(0, [property[@"angle"] floatValue], 0);
    node.referenceFrame = RFReferenceFrameCamera;

    NSString *key = [NSString stringWithFormat:@"%@", property[@"id"]];
    NSLog(@"[RCTARKitNodes] Add model %@ to Camera frame at (%.2f, %.2f, %.2f)", key, node.position.x, node.position.y, node.position.z);
    if (key) {
        [self registerNode:node forKey:key];
    }
    [self.cameraOrigin addChildNode:node];
}

- (void)addNodeToFrontOfCameraFrame:(SCNNode *)node property:(NSDictionary *)property {
    node.position = [self getPositionFromProperty:property inReferenceFrame:RFReferenceFrameFrontOfCamera];
    node.eulerAngles = SCNVector3Make(0, [property[@"angle"] floatValue], 0);
    node.referenceFrame = RFReferenceFrameFrontOfCamera;

    NSString *key = [NSString stringWithFormat:@"%@", property[@"id"]];
    NSLog(@"[RCTARKitNodes] Add model %@ to FrontOfCamera frame at (%.2f, %.2f, %.2f)", key, node.position.x, node.position.y, node.position.z);
    if (key) {
        [self registerNode:node forKey:key];
    }
    [self.frontOfCamera addChildNode:node];
}

- (SCNVector3)getPositionFromProperty:(NSDictionary *)property inReferenceFrame:(RFReferenceFrame)referenceFrame {
    CGFloat x = [property[@"x"] floatValue];
    CGFloat y = [property[@"y"] floatValue];
    CGFloat z = [property[@"z"] floatValue];

    if (referenceFrame == RFReferenceFrameLocal) {
        if (property[@"x"] == NULL) {
            x = self.cameraOrigin.position.x - self.localOrigin.position.x;
        }
        if (property[@"y"] == NULL) {
            y = self.cameraOrigin.position.y - self.localOrigin.position.y;
        }
        if (property[@"z"] == NULL) {
            z = self.cameraOrigin.position.z - self.localOrigin.position.z;
        }
    }

    return SCNVector3Make(x, y, z);
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

- (void)clear {

  for(id key in self.nodes) {
      [self removeNodeForKey:key]
  }
}



#pragma mark - RCTARKitSessionDelegate
- (void)session:(ARSession *)session didUpdateFrame:(ARFrame *)frame {
    simd_float4 pos = frame.camera.transform.columns[3];
    self.cameraOrigin.position = SCNVector3Make(pos.x, pos.y, pos.z);
    simd_float4 z = frame.camera.transform.columns[2];
    self.cameraDirection = SCNVector3Make(-z.x, -z.y, -z.z);
    self.cameraOrigin.eulerAngles = SCNVector3Make(0, atan2f(z.x, z.z), 0);
    self.frontOfCamera.position = SCNVector3Make(pos.x - 0.2 * z.x, pos.y  - 0.2 * z.y, pos.z - 0.2 * z.z);
    self.frontOfCamera.eulerAngles = self.cameraOrigin.eulerAngles;
}

@end
