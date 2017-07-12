# react-native-arkit

[![npm version](https://img.shields.io/npm/v/react-native-arkit.svg?style=flat)](https://www.npmjs.com/package/react-native-arkit)
[![npm downloads](https://img.shields.io/npm/dm/react-native-arkit.svg?style=flat)](https://www.npmjs.com/package/react-native-arkit)

React Native binding for iOS ARKit.

**Note**: ARKit is only supported by devices with A9+ processor (iPhone 6s/7/SE, iPad 2017/Pro) on [iOS 11 beta](https://developer.apple.com/download/). You also need [Xcode 9 beta](https://developer.apple.com/download/) to build the project.

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
  render() {
    return (
      <View style={{ flex: 1 }}>
        <ARKit
          style={{ flex: 1 }}
          debug
          planeDetection
          lightEstimation
          onPlaneDetected={console.log}
          onPlaneUpdate={console.log}
        />
      </View>
    );
  }
}

AppRegistry.registerComponent('ReactNativeARKit', () => ReactNativeARKit);

```

## Contributing

If you find a bug or would like to request a new feature, just [open an issue](https://github.com/HippoAR/react-native-arkit/issues/new). Your contributions are always welcome! Submit a pull request and see `contribution.md` for guidelines.
