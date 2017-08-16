//
//  ARSphere.js
//
//  Created by HippoAR on 8/12/17.
//  Copyright © 2017 HippoAR. All rights reserved.
//

import PropTypes from 'prop-types';
import React, { Component } from 'react';
import { NativeModules } from 'react-native';
import id from './lib/id';

const ARSphereManager = NativeModules.ARSphereManager;

class ARSphere extends Component {
  identifier = null;

  componentWillMount() {
    this.identifier = this.props.id || id();
    ARSphereManager.mount({
      id: this.identifier,
      ...this.props.pos,
      ...this.props.shape,
    });
  }

  componentWillUnmount() {
    ARSphereManager.unmount(this.identifier);
  }

  render() {
    return null;
  }
}

ARSphere.propTypes = {
  pos: PropTypes.shape({
    x: PropTypes.number,
    y: PropTypes.number,
    z: PropTypes.number,
    frame: PropTypes.string,
  }),
  shape: PropTypes.shape({
    radius: PropTypes.number,
  }),
};

module.exports = ARSphere;
