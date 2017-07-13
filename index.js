//
//  index.js
//
//  Created by HippoAR on 7/9/17.
//  Copyright © 2017 HippoAR. All rights reserved.
//

import PropTypes from 'prop-types';
import React from 'react';
import { NativeModules, requireNativeComponent } from 'react-native';

const ARKitManager = NativeModules.ARKitManager;

class ARKit extends React.Component {
  render() {
    return <RCTARKit
      {...this.props}
      onPlaneDetected={this.callback('onPlaneDetected')}
      onPlaneUpdate={this.callback('onPlaneUpdate')}
    />;
  }

  getCameraPosition() {
    return ARKitManager.getCameraPosition();
  }

  addCube(object) {
    return ARKitManager.addCube(object);
  }

  callback(name) {
    return event => {
      if (!this.props[name]) {
        return;
      }
      this.props[name](event.nativeEvent);
    };
  }
}

ARKit.propTypes = {
  debug: PropTypes.bool,
  planeDetection: PropTypes.bool,
  lightEstimation: PropTypes.bool,
  onPlaneDetected: PropTypes.func,
  onPlaneUpdate: PropTypes.func,
};

const RCTARKit = requireNativeComponent('RCTARKit', ARKit);

module.exports = ARKit;
