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

Sample React Native ARKit App
```javascript
import React, { Component } from 'react';
import { AppRegistry, View } from 'react-native';
import ARKit from 'react-native-arkit';

export default class ReactNativeARKit extends Component {
  componentDidMount() {
    // Add a cube in the scene. Only support cube geometry at the moment
    this.arkit.addBox({ x: 0, y: 0, z: 0, width: 0.1, height: 0.1, length: 0.1, chamfer: 0.01 });
    this.arkit.addSphere({ x: 0.2, y: 0, z: 0, radius: 0.05 });
    this.arkit.addCylinder({ x: 0.4, y: 0, z: 0, radius: 0.05, height: 0.1 });
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

## Contributing

If you find a bug or would like to request a new feature, just [open an issue](https://github.com/HippoAR/react-native-arkit/issues/new). Your contributions are always welcome! Submit a pull request and see [`CONTRIBUTING.md`](CONTRIBUTING.md) for guidelines.
