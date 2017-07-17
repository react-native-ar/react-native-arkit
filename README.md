# react-native-arkit

[![npm version](https://img.shields.io/npm/v/react-native-arkit.svg?style=flat)](https://www.npmjs.com/package/react-native-arkit)
[![npm downloads](https://img.shields.io/npm/dm/react-native-arkit.svg?style=flat)](https://www.npmjs.com/package/react-native-arkit)

React Native binding for iOS ARKit.

**Note**: ARKit is only supported by devices with A9 or later processors (iPhone 6s/7/SE, iPad 2017/Pro) on [iOS 11 beta](https://developer.apple.com/download/). You also need [Xcode 9 beta](https://developer.apple.com/download/) to build the project.

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

You can refer to this [tutorial](https://medium.com/@HippoAR/how-to-make-your-own-arkit-app-in-5-minutes-using-react-native-9d7ce109a4c2) for how to use `react-native-arkit`. A simple sample React Native ARKit App is as follows

```javascript
// index.ios.js

import React, { Component } from 'react';
import { AppRegistry, View } from 'react-native';
import ARKit from 'react-native-arkit';

export default class ReactNativeARKit extends Component {
  componentDidMount() {
    // Add a cube in the scene. Only support cube geometry at the moment
    this.arkit.addBox({ x: 0, y: 0, z: 0, width: 0.1, height: 0.1, length: 0.1, chamfer: 0.01 });
    this.arkit.addSphere({ x: 0.2, y: 0, z: 0, radius: 0.05 });
    this.arkit.addCylinder({ x: 0.4, y: 0, z: 0, radius: 0.05, height: 0.1 });
    this.arkit.addCone({ x: 0, y: 0.2, z: 0, topR: 0, bottomR: 0.05, height: 0.1 });
    this.arkit.addPyramid({ x: 0.2, y: 0.15, z: 0, width: 0.1, height: 0.1, length: 0.1 });
    this.arkit.addTube({ x: 0.4, y: 0.2, z: 0, innerR: 0.03, outerR: 0.05, height: 0.1 });
    this.arkit.addTorus({ x: 0, y: 0.4, z: 0, ringR: 0.06, pipeR: 0.02 });
    this.arkit.addCapsule({ x: 0.2, y: 0.4, z: 0, capR: 0.02, height: 0.06 });
    this.arkit.addPlane({ x: 0.4, y: 0.4, z: 0, width: 0.1, height: 0.1 });
  }

  render() {
    return (
      <View style={{ flex: 1 }}>
        <ARKit
          ref={arkit => this.arkit = arkit}
          style={{ flex: 1 }}
          debug
          planeDetection
          lightEstimation
          onPlaneDetected={console.log} // event listener for plane detection
          onPlaneUpdate={console.log} // event listener for plane update
        />
      </View>
    );
  }
}

AppRegistry.registerComponent('ReactNativeARKit', () => ReactNativeARKit);

```

<img src="screenshots/geometries.jpg" width="250">

## Contributing

If you find a bug or would like to request a new feature, just [open an issue](https://github.com/HippoAR/react-native-arkit/issues/new). Your contributions are always welcome! Submit a pull request and see [`CONTRIBUTING.md`](CONTRIBUTING.md) for guidelines.
