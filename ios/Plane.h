//
//  Plane.h
//  RCTARKit
//
//  Created by Zehao Li on 7/10/17.
//  Copyright © 2017 HippoAR. All rights reserved.
//

#import <SceneKit/SceneKit.h>
#import <ARKit/ARKit.h>

@interface Plane : SCNNode
- (instancetype)initWithAnchor:(ARPlaneAnchor *)anchor isHidden:(BOOL)hidden;
- (void)update:(ARPlaneAnchor *)anchor;
- (void)setTextureScale;
- (void)hide;
@property (nonatomic, retain) ARPlaneAnchor *anchor;
@property (nonatomic, retain) SCNBox *planeGeometry;
@end
