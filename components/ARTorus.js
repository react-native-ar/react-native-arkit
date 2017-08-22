//
//  ARTorus.js
//
//  Created by HippoAR on 8/12/17.
//  Copyright © 2017 HippoAR. All rights reserved.
//

import PropTypes from 'prop-types';
import React, { Component } from 'react';
import { NativeModules } from 'react-native';
import id from './lib/id';

const ARTorusManager = NativeModules.ARTorusManager;

class ARTorus extends Component {
  identifier = null;

  componentWillMount() {
    this.identifier = this.props.id || id();
    ARTorusManager.mount({
      id: this.identifier,
      ...this.props.pos,
      ...this.props.shape,
    });
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
    color: PropTypes.string,
  }),
};

module.exports = ARTorus;
