//
//  ARModel.js
//
//  Created by HippoAR on 8/12/17.
//  Copyright © 2017 HippoAR. All rights reserved.
//

import PropTypes from 'prop-types';
import React, { Component } from 'react';
import { NativeModules } from 'react-native';
import isEqual from 'lodash/isEqual';
import id from './lib/id';

const ARModelManager = NativeModules.ARModelManager;

class ARModel extends Component {
  identifier = null;

  componentWillMount() {
    this.identifier = this.props.id || id();
    ARModelManager.mount({
      id: this.identifier,
      ...this.props.pos,
      ...this.props.shader,
      ...this.props.model,
    });
  }

  componentWillReceiveProps(newProps) {
    if (!isEqual(newProps, this.props)) {
      ARModelManager.mount({
        id: this.identifier,
        ...newProps.pos,
        ...newProps.shader,
        ...newProps.model,
      });
    }
  }

  componentWillUnmount() {
    ARModelManager.unmount(this.identifier);
  }

  render() {
    return null;
  }
}

ARModel.propTypes = {
  pos: PropTypes.shape({
    x: PropTypes.number,
    y: PropTypes.number,
    z: PropTypes.number,
    angle: PropTypes.number,
    frame: PropTypes.string,
  }),
  shader: PropTypes.shape({
    metalness: PropTypes.number,
    roughness: PropTypes.number,
  }),
  model: PropTypes.shape({
    file: PropTypes.string,
    node: PropTypes.string,
    scale: PropTypes.number,
  }),
};

module.exports = ARModel;
