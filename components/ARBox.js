//
//  ARBox.js
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

const ARBoxManager = NativeModules.ARBoxManager;

class ARBox extends Component {
  identifier = null;

  componentWillMount() {
    this.identifier = this.props.id || generateId();
    parseColorWrapper(ARBoxManager.mount)({
      id: this.identifier,
      ...this.props.pos,
      ...this.props.shader,
      ...this.props.shape,
    });
  }

  componentWillReceiveProps(newProps) {
    if (!isEqual(newProps, this.props)) {
      parseColorWrapper(ARBoxManager.mount)({
        id: this.identifier,
        ...newProps.pos,
        ...newProps.shader,
        ...newProps.shape,
      });
    }
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
  shape: PropTypes.shape({
    width: PropTypes.number,
    height: PropTypes.number,
    length: PropTypes.number,
    chamfer: PropTypes.number,
  }),
  shader: PropTypes.shape({
    color: PropTypes.string,
    metalness: PropTypes.number,
    roughness: PropTypes.number,
  }),
};

module.exports = ARBox;
