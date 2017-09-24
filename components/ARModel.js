//
//  ARModel.js
//
//  Created by HippoAR on 8/12/17.
//  Copyright © 2017 HippoAR. All rights reserved.
//

import PropTypes from 'prop-types';
import { Component } from 'react';
import { NativeModules } from 'react-native';
import isEqual from 'lodash/isEqual';
import generateId from './lib/generateId';

const ARModelManager = NativeModules.ARModelManager;

class ARModel extends Component {
  identifier = null;

  componentWillMount() {
    this.identifier = this.props.id || generateId();
    ARModelManager.mount({
      id: this.identifier,
      ...this.props.pos,
      ...this.props.model,
      ...this.props.shader,
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
  model: PropTypes.shape({
    file: PropTypes.string,
    node: PropTypes.string,
    scale: PropTypes.number,
    alpha: PropTypes.number,
  }),
  shader: PropTypes.shape({
    metalness: PropTypes.number,
    roughness: PropTypes.number,
  }),
};

module.exports = ARModel;
