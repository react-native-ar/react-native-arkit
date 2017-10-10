//
//  index.js
//
//  Created by HippoAR on 7/9/17.
//  Copyright © 2017 HippoAR. All rights reserved.
//

import ARKit from './ARKit';
import DeviceMotion from './DeviceMotion';

import ARBox from './components/ARBox';
import ARSphere from './components/ARSphere';
import ARCylinder from './components/ARCylinder';
import ARCone from './components/ARCone';
import ARPyramid from './components/ARPyramid';
import ARTube from './components/ARTube';
import ARTorus from './components/ARTorus';
import ARCapsule from './components/ARCapsule';
import ARPlane from './components/ARPlane';
import ARText from './components/ARText';
import ARModel from './components/ARModel';
import ARSprite from './components/ARSprite';
import ARGroup from './components/ARGroup';
import ARLight from './components/ARLight';


ARKit.Box = ARBox;
ARKit.Sphere = ARSphere;
ARKit.Cylinder = ARCylinder;
ARKit.Cone = ARCone;
ARKit.Pyramid = ARPyramid;
ARKit.Tube = ARTube;
ARKit.Torus = ARTorus;
ARKit.Capsule = ARCapsule;
ARKit.Plane = ARPlane;
ARKit.Text = ARText;
ARKit.Model = ARModel;
ARKit.Sprite = ARSprite;
ARKit.Group = ARGroup;
ARKit.Light = ARLight;


module.exports = {
  ARKit,
  DeviceMotion,
  ARBox,
  ARSphere,
  ARCylinder,
  ARCone,
  ARPyramid,
  ARTube,
  ARTorus,
  ARCapsule,
  ARPlane,
  ARText,
  ARModel,
  ARGroup,
  ARLight,
};
