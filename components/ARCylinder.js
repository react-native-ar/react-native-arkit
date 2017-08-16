//
//  ARCylinder.js
//
//  Created by HippoAR on 8/12/17.
//  Copyright © 2017 HippoAR. All rights reserved.
//

import PropTypes from 'prop-types';
import React, { Component } from 'react';
import { NativeModules } from 'react-native';
import id from './lib/id';

const ARCylinderManager = NativeModules.ARCylinderManager;

class ARCylinder extends Component {
  identifier = null;

  componentWillMount() {
    this.identifier = this.props.id || id();
    ARCylinderManager.mount({
      id: this.identifier,
      ...this.props.pos,
      ...this.props.shape,
    });
  }

  componentWillUnmount() {
    ARCylinderManager.unmount(this.identifier);
  }

  render() {
    return null;
  }
}

ARCylinder.propTypes = {
  pos: PropTypes.shape({
    x: PropTypes.number,
    y: PropTypes.number,
    z: PropTypes.number,
    frame: PropTypes.string,
  }),
  shape: PropTypes.shape({
    radius: PropTypes.number,
    height: PropTypes.number,
  }),
};

module.exports = ARCylinder;
