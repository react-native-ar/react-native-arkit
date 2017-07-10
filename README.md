# react-native-arkit
React Native binding for iOS ARKit

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
        />
      </View>
    );
  }
}

AppRegistry.registerComponent('ReactNativeARKit', () => ReactNativeARKit);

```
