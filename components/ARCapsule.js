//
//  ARCapsule.js
//
//  Created by HippoAR on 8/12/17.
//  Copyright © 2017 HippoAR. All rights reserved.
//

import PropTypes from 'prop-types';
import React, { Component } from 'react';
import { NativeModules } from 'react-native';
import id from './lib/id';

const ARCapsuleManager = NativeModules.ARCapsuleManager;

class ARCapsule extends Component {
  identifier = null;

  componentWillMount() {
    this.identifier = this.props.id || id();
    ARCapsuleManager.mount({
      id: this.identifier,
      ...this.props.pos,
      ...this.props.shape,
    });
  }

  componentWillUnmount() {
    ARCapsuleManager.unmount(this.identifier);
  }

  render() {
    return null;
  }
}

ARCapsule.propTypes = {
  pos: PropTypes.shape({
    x: PropTypes.number,
    y: PropTypes.number,
    z: PropTypes.number,
    frame: PropTypes.string,
  }),
  shape: PropTypes.shape({
    capR: PropTypes.number,
    height: PropTypes.number,
  }),
};

module.exports = ARCapsule;
