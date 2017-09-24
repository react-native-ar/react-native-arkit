//
//  ARSphere.js
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

const ARSphereManager = NativeModules.ARSphereManager;

class ARSphere extends Component {
  identifier = null;

  componentWillMount() {
    this.identifier = this.props.id || generateId();
    parseColorWrapper(ARSphereManager.mount)({
      id: this.identifier,
      ...this.props.pos,
      ...this.props.shader,
      ...this.props.shape,
    });
  }

  componentWillReceiveProps(newProps) {
    if (!isEqual(newProps, this.props)) {
      parseColorWrapper(ARSphereManager.mount)({
        id: this.identifier,
        ...newProps.pos,
        ...newProps.shader,
        ...newProps.shape,
      });
    }
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
  shader: PropTypes.shape({
    color: PropTypes.string,
    metalness: PropTypes.number,
    roughness: PropTypes.number,
  }),
};

module.exports = ARSphere;
