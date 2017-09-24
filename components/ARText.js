//
//  ARText.js
//
//  Created by HippoAR on 8/12/17.
//  Copyright © 2017 HippoAR. All rights reserved.
//

import PropTypes from 'prop-types';
import React, { Component } from 'react';
import { NativeModules } from 'react-native';
import generateId from './lib/generateId';
import { parseColorWrapper } from '../parseColor';

const ARTextManager = NativeModules.ARTextManager;

class ARText extends Component {
  identifier = null;

  componentWillMount() {
    this.identifier = this.props.id || generateId();
    parseColorWrapper(ARTextManager.mount)({
      id: this.identifier,
      text: this.props.text,
      ...this.props.pos,
      ...this.props.font,
      ...this.props.shader,
    });
  }

  componentWillReceiveProps(newProps) {
    if (!isEqual(newProps, this.props)) {
      parseColorWrapper(ARTextManager.mount)({
        id: this.identifier,
        text: newProps.text,
        ...newProps.pos,
        ...newProps.font,
        ...this.props.shader,
      });
    }
  }

  componentWillUnmount() {
    ARTextManager.unmount(this.identifier);
  }

  render() {
    return null;
  }
}

ARText.propTypes = {
  text: PropTypes.string,
  pos: PropTypes.shape({
    x: PropTypes.number,
    y: PropTypes.number,
    z: PropTypes.number,
    angle: PropTypes.number,
    frame: PropTypes.string,
  }),
  font: PropTypes.shape({
    name: PropTypes.string,
    // weight: PropTypes.string,
    size: PropTypes.number,
    depth: PropTypes.number,
    chamfer: PropTypes.number,
  }),
  shader: PropTypes.shape({
    color: PropTypes.string,
    metalness: PropTypes.number,
    roughness: PropTypes.number,
  }),
};

module.exports = ARText;
