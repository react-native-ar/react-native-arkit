//
//  ARTube.js
//
//  Created by HippoAR on 8/12/17.
//  Copyright © 2017 HippoAR. All rights reserved.
//

import PropTypes from 'prop-types';
import React, { Component } from 'react';
import { NativeModules } from 'react-native';
import id from './lib/id';

const ARTubeManager = NativeModules.ARTubeManager;

class ARTube extends Component {
  identifier = null;

  componentWillMount() {
    this.identifier = this.props.id || id();
    ARTubeManager.mount({
      id: this.identifier,
      ...this.props.pos,
      ...this.props.shape,
    });
  }

  componentWillUnmount() {
    ARTubeManager.unmount(this.identifier);
  }

  render() {
    return null;
  }
}

ARTube.propTypes = {
  pos: PropTypes.shape({
    x: PropTypes.number,
    y: PropTypes.number,
    z: PropTypes.number,
    frame: PropTypes.string,
  }),
  shape: PropTypes.shape({
    innerR: PropTypes.number,
    outerR: PropTypes.number,
    height: PropTypes.number,
    color: PropTypes.string,
  }),
};

module.exports = ARTube;
