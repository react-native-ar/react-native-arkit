//
//  ARCylinder.js
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

const ARCylinderManager = NativeModules.ARCylinderManager;

class ARCylinder extends Component {
  identifier = null;

  componentWillMount() {
    this.identifier = this.props.id || generateId();
    parseColorWrapper(ARCylinderManager.mount)({
      id: this.identifier,
      ...this.props.pos,
      ...this.props.shape,
      ...this.props.shader,
    });
  }

  componentWillReceiveProps(newProps) {
    if (!isEqual(newProps, this.props)) {
      parseColorWrapper(ARCylinderManager.mount)({
        id: this.identifier,
        ...newProps.pos,
        ...newProps.shape,
        ...newProps.shader,
      });
    }
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
  shader: PropTypes.shape({
    color: PropTypes.string,
    metalness: PropTypes.number,
    roughness: PropTypes.number,
  }),
};

module.exports = ARCylinder;
