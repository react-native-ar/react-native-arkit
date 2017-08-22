//
//  ARBox.js
//
//  Created by HippoAR on 8/12/17.
//  Copyright © 2017 HippoAR. All rights reserved.
//

import PropTypes from 'prop-types';
import React, { Component } from 'react';
import { NativeModules } from 'react-native';
import id from './lib/id';
import { parseColorWrapper } from '../parseColor';

const ARBoxManager = NativeModules.ARBoxManager;

class ARBox extends Component {
  identifier = null;

  componentWillMount() {
    this.identifier = this.props.id || id();
    parseColorWrapper(ARBoxManager.mount)({
      id: this.identifier,
      ...this.props.pos,
      ...this.props.shader,
      ...this.props.shape,
    });
  }

  componentWillUnmount() {
    ARBoxManager.unmount(this.identifier);
  }

  render() {
    return null;
  }
}

ARBox.propTypes = {
  pos: PropTypes.shape({
    x: PropTypes.number,
    y: PropTypes.number,
    z: PropTypes.number,
    frame: PropTypes.string,
  }),
  shader: PropTypes.shape({
    metalness: PropTypes.number,
    roughness: PropTypes.number,
  }),
  shape: PropTypes.shape({
    width: PropTypes.number,
    height: PropTypes.number,
    length: PropTypes.number,
    chamfer: PropTypes.number,
    color: PropTypes.string,
  }),
};

module.exports = ARBox;
