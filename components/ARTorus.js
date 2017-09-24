//
//  ARTorus.js
//
//  Created by HippoAR on 8/12/17.
//  Copyright © 2017 HippoAR. All rights reserved.
//

import PropTypes from 'prop-types';
import { Component } from 'react';
import { NativeModules } from 'react-native';
import isEqual from 'lodash/isEqual';
import generateId from './lib/generateId';
import { parseColorWrapper } from '../parseColor';

const ARTorusManager = NativeModules.ARTorusManager;

class ARTorus extends Component {
  identifier = null;

  componentWillMount() {
    this.identifier = this.props.id || generateId();
    parseColorWrapper(ARTorusManager.mount)({
      id: this.identifier,
      ...this.props.pos,
      ...this.props.shape,
      ...this.props.shader,
    });
  }

  componentWillReceiveProps(newProps) {
    if (!isEqual(newProps, this.props)) {
      parseColorWrapper(ARTorusManager.mount)({
        id: this.identifier,
        ...newProps.pos,
        ...newProps.shape,
        ...newProps.shader,
      });
    }
  }

  componentWillUnmount() {
    ARTorusManager.unmount(this.identifier);
  }

  render() {
    return null;
  }
}

ARTorus.propTypes = {
  pos: PropTypes.shape({
    x: PropTypes.number,
    y: PropTypes.number,
    z: PropTypes.number,
    frame: PropTypes.string,
  }),
  shape: PropTypes.shape({
    ringR: PropTypes.number,
    pipeR: PropTypes.number,
  }),
  shader: PropTypes.shape({
    color: PropTypes.string,
    metalness: PropTypes.number,
    roughness: PropTypes.number,
  }),
};

module.exports = ARTorus;
