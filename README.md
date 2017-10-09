# react-native-arkit

[![npm version](https://img.shields.io/npm/v/react-native-arkit.svg?style=flat)](https://www.npmjs.com/package/react-native-arkit)
[![npm downloads](https://img.shields.io/npm/dm/react-native-arkit.svg?style=flat)](https://www.npmjs.com/package/react-native-arkit)

React Native binding for iOS ARKit.

**Tutorial**: [How to make an ARKit app in 5 minutes using React Native](https://medium.com/@HippoAR/how-to-make-your-own-arkit-app-in-5-minutes-using-react-native-9d7ce109a4c2)

**Sample Project**: https://github.com/HippoAR/ReactNativeARKit

**Note**: ARKit is only supported by devices with A9 or later processors (iPhone 6s/7/SE/8/X, iPad 2017/Pro) on iOS 11. You also need Xcode 9 to build the project.

There is a Slack group that anyone can join for help / support / general questions.

[**Join Slack**](https://join.slack.com/t/react-native-ar/shared_invite/enQtMjUzMzg3MjM0MTQ5LWU3Nzg2YjI4MGRjMTM1ZDBlNmIwYTE4YmM0M2U0NmY2YjBiYzQ4YzlkODExMTA0NDkwMzFhYWY4ZDE2M2Q4NGY)

## Getting started

`$ npm install react-native-arkit --save`

### Mostly automatic installation

`$ react-native link react-native-arkit`

### Manual installation


#### iOS

1. In XCode, in the project navigator, right click `Libraries` ➜ `Add Files to [your project's name]`
2. Go to `node_modules` ➜ `react-native-arkit` and add `RCTARKit.xcodeproj`
3. In XCode, in the project navigator, select your project. Add `libRCTARKit.a` to your project's `Build Phases` ➜ `Link Binary With Libraries`
4. Run your project (`Cmd+R`)<


## Usage

A simple sample React Native ARKit App

```javascript
// index.ios.js

import React, { Component } from 'react';
import { AppRegistry, View } from 'react-native';
import { ARKit } from 'react-native-arkit';

export default class ReactNativeARKit extends Component {
  render() {
    return (
      <View style={{ flex: 1 }}>
        <ARKit
          style={{ flex: 1 }}
          debug
          planeDetection
          lightEstimation
          onPlaneDetected={console.log} // event listener for plane detection
          onPlaneUpdate={console.log} // event listener for plane update
        >
          <ARKit.Box
            position={{ x: 0, y: 0, z: 0 }}
            shape={{ width: 0.1, height: 0.1, length: 0.1, chamfer: 0.01 }}
          />
          <ARKit.Sphere
            position={{ x: 0.2, y: 0, z: 0 }}
            shape={{ radius: 0.05 }}
          />
          <ARKit.Cylinder
            position={{ x: 0.4, y: 0, z: 0 }}
            shape={{ radius: 0.05, height: 0.1 }}
          />
          <ARKit.Cone
            position={{ x: 0, y: 0.2, z: 0 }}
            shape={{ topR: 0, bottomR: 0.05, height: 0.1 }}
          />
          <ARKit.Pyramid
            position={{ x: 0.2, y: 0.15, z: 0 }}
            shape={{ width: 0.1, height: 0.1, length: 0.1 }}
          />
          <ARKit.Tube
            position={{ x: 0.4, y: 0.2, z: 0 }}
            shape={{ innerR: 0.03, outerR: 0.05, height: 0.1 }}
          />
          <ARKit.Torus
            position={{ x: 0, y: 0.4, z: 0 }}
            shape={{ ringR: 0.06, pipeR: 0.02 }}
          />
          <ARKit.Capsule
            position={{ x: 0.2, y: 0.4, z: 0 }}
            shape={{ capR: 0.02, height: 0.06 }}
          />
          <ARKit.Plane
            position={{ x: 0.4, y: 0.4, z: 0 }}
            shape={{ width: 0.1, height: 0.1 }}
          />
          <ARKit.Text
            text="ARKit is Cool!"
            position={{ x: 0.2, y: 0.6, z: 0 }}
            font={{ size: 0.15, depth: 0.05 }}
          />
          <ARKit.Model
            position={{ x: -0.2, y: 0, z: 0, frame: 'local' }}
            model={{
              file: 'art.scnassets/ship.scn', // make sure you have the model file in the ios project
              scale: 0.01,
            }}
          />
        </ARKit>
      </View>
    );
  }
}

AppRegistry.registerComponent('ReactNativeARKit', () => ReactNativeARKit);

```

<img src="screenshots/geometries.jpg" width="250">

### Components

#### `<ARKit />`

##### Props

| Prop | Type | Default | Note |
|---|---|---|---|
| `debug` | `Boolean` | `false` | Debug mode will show the 3D axis and feature points detected.
| `planeDetection` | `Boolean` | `false` | ARKit plane detection.
| `lightEstimation` | `Boolean` | `false` | ARKit light estimation.

##### Events

| Event Name | Returns | Notes
|---|---|---|
| `onPlaneDetected` | `{ id, center, extent }` | When a plane is first detected.
| `onPlaneUpdate` | `{ id, center, extent }` | When a detected plane is updated

##### Static methods

| Method Name | Arguments |  Notes
|---|---|---|
| `snapshot` |  |  | Take a screenshot (will save to Photo Library) |
| `snapshotCamera` |  | Take a screenshot without 3d models (will save to Photo Library) |
| `getCameraPosition` |  | Get the current position of the `ARCamera` |
| `focusScene` |  | Sets the scene's position/rotation to where it was when first rendered (but now relative to your device's current position/rotation) |
| `hitTestPlanes` | point, type  |  check if a plane has ben hit by point (`{x,y}`) with detection type (any of `ARKit.ARHitTestResultType`). See https://developer.apple.com/documentation/arkit/arhittestresulttype?language=objc for further information |
| `hitTestSceneObjects` | point |  check if a scene object has ben hit by point (`{x,y}`) |



#### [`<ARKit.Box />`](https://developer.apple.com/documentation/scenekit/scnbox)

##### Props

| Prop | Type |
|---|---|
| `position` | `{ x, y, z }` |
| `eulerAngles` | `{ x, y, z }` |
| `shape` | `{ width, height, length, chamfer }` |
| `material` | `{ diffuse, metalness, roughness, lightingModel }` |

#### [`<ARKit.Sphere />`](https://developer.apple.com/documentation/scenekit/scnsphere)

##### Props

| Prop | Type |
|---|---|
| `position` | `{ x, y, z }` |
| `eulerAngles` | `{ x, y, z }` |
| `shape` | `{ radius }` |
| `material` | `{ diffuse, metalness, roughness, lightingModel }` |

#### [`<ARKit.Cylinder />`](https://developer.apple.com/documentation/scenekit/scncylinder)

##### Props

| Prop | Type |
|---|---|
| `position` | `{ x, y, z }` |
| `eulerAngles` | `{ x, y, z }` |
| `shape` | `{ radius, height }` |
| `material` | `{ diffuse, metalness, roughness, lightingModel }` |

#### [`<ARKit.Cone />`](https://developer.apple.com/documentation/scenekit/scncone)

##### Props

| Prop | Type |
|---|---|
| `position` | `{ x, y, z }` |
| `eulerAngles` | `{ x, y, z }` |
| `shape` | `{ topR, bottomR, height }` |
| `material` | `{ diffuse, metalness, roughness, lightingModel }` |

#### [`<ARKit.Pyramid />`](https://developer.apple.com/documentation/scenekit/scnpyramid)

##### Props

| Prop | Type |
|---|---|
| `position` | `{ x, y, z }` |
| `eulerAngles` | `{ x, y, z }` |
| `shape` | `{ width, height, length }` |
| `material` | `{ diffuse, metalness, roughness, lightingModel }` |

#### [`<ARKit.Tube />`](https://developer.apple.com/documentation/scenekit/scntube)

##### Props

| Prop | Type |
|---|---|
| `position` | `{ x, y, z }` |
| `eulerAngles` | `{ x, y, z }` |
| `shape` | `{ innerR, outerR, height }` |
| `material` | `{ diffuse, metalness, roughness, lightingModel }` |

#### [`<ARKit.Torus />`](https://developer.apple.com/documentation/scenekit/scntorus)

##### Props

| Prop | Type |
|---|---|
| `position` | `{ x, y, z }` |
| `eulerAngles` | `{ x, y, z }` |
| `shape` | `{ ringR, pipeR }` |
| `material` | `{ diffuse, metalness, roughness, lightingModel }` |

#### [`<ARKit.Capsule />`](https://developer.apple.com/documentation/scenekit/scncapsule)

##### Props

| Prop | Type |
|---|---|
| `position` | `{ x, y, z }` |
| `eulerAngles` | `{ x, y, z }` |
| `shape` | `{ capR, height }` |
| `material` | `{ diffuse, metalness, roughness, lightingModel }` |

#### [`<ARKit.Plane />`](https://developer.apple.com/documentation/scenekit/scnplane)

##### Props

| Prop | Type |
|---|---|
| `position` | `{ x, y, z }` |
| `eulerAngles` | `{ x, y, z }` |
| `shape` | `{ width, length }` |
| `material` | `{ diffuse, metalness, roughness, lightingModel }` |

#### [`<ARKit.Text />`](https://developer.apple.com/documentation/scenekit/scntext)

##### Props

| Prop | Type |
|---|---|
| `text` | `String` |
| `position` | `{ x, y, z }` |
| `eulerAngles` | `{ x, y, z }` |
| `font` | `{ name, size, depth, chamfer }` |
| `material` | `{ diffuse, metalness, roughness, lightingModel }` |


#### `<ARKit.Model />`

SceneKit only supports `.scn` and `.dae` formats.

##### Props

| Prop | Type |
|---|---|
| `position` | `{ x, y, z }` |
| `eulerAngles` | `{ x, y, z }` |
| `model` | `{ file, node, scale, alpha }` |


## Contributing

If you find a bug or would like to request a new feature, just [open an issue](https://github.com/HippoAR/react-native-arkit/issues/new). Your contributions are always welcome! Submit a pull request and see [`CONTRIBUTING.md`](CONTRIBUTING.md) for guidelines.
