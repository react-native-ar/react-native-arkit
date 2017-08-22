//
//  ARPyramid.js
//
//  Created by HippoAR on 8/12/17.
//  Copyright © 2017 HippoAR. All rights reserved.
//

import PropTypes from 'prop-types';
import React, { Component } from 'react';
import { NativeModules } from 'react-native';
import id from './lib/id';

const ARPyramidManager = NativeModules.ARPyramidManager;

class ARPyramid extends Component {
  identifier = null;

  componentWillMount() {
    this.identifier = this.props.id || id();
    ARPyramidManager.mount({
      id: this.identifier,
      ...this.props.pos,
      ...this.props.shape,
    });
  }

  componentWillUnmount() {
    ARPyramidManager.unmount(this.identifier);
  }

  render() {
    return null;
  }
}

ARPyramid.propTypes = {
  pos: PropTypes.shape({
    x: PropTypes.number,
    y: PropTypes.number,
    z: PropTypes.number,
    frame: PropTypes.string,
  }),
  shape: PropTypes.shape({
    width: PropTypes.number,
    length: PropTypes.number,
    height: PropTypes.number,
    color: PropTypes.string,
  }),
};

module.exports = ARPyramid;
