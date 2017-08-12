//
//  ARModel.js
//
//  Created by HippoAR on 8/12/17.
//  Copyright © 2017 HippoAR. All rights reserved.
//

import PropTypes from 'prop-types';
import React, { Component } from 'react';
import { NativeModules } from 'react-native';
import id from './lib/id';

const ARModelManager = NativeModules.ARModelManager;

class ARModel extends Component {
  identifier = null;

  componentWillMount() {
    this.identifier = this.props.id || id();
    ARModelManager.mount({
      id: this.identifier,
      ...this.props.pos,
      ...this.props.model,
    });
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
    frame: PropTypes.string,
  }),
  model: PropTypes.shape({
    file: PropTypes.string,
    node: PropTypes.string,
    scale: PropTypes.string,
  }),
};

module.exports = ARModel;
