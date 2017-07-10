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
    return <RCTARKit {...this.props} />;
  }

  getCameraPosition() {
    return ARKitManager.getCameraPosition();
  }
}

ARKit.propTypes = {
  debug: PropTypes.bool,
  planeDetection: PropTypes.bool,
  lightEstimation: PropTypes.bool,
};

const RCTARKit = requireNativeComponent('RCTARKit', ARKit);

module.exports = ARKit;
