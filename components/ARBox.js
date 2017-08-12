//
//  ARBox.js
//
//  Created by HippoAR on 8/12/17.
//  Copyright © 2017 HippoAR. All rights reserved.
//

import PropTypes from 'prop-types';
import React, { Component } from 'react';
import { NativeModules } from 'react-native';
import id from './lib/id';

const ARBoxManager = NativeModules.ARBoxManager;

class Box extends Component {
  identifier = null;

  componentWillMount() {
    this.identifier = id();
    ARBoxManager.mount({
      id: this.identifier,
      ...this.props.pos,
      ...this.props.shape,
    });
  }

  componentWillUnmount() {
    ARBoxManager.unmount(this.identifier);
  }

  render() {
    return null;
  }
}

Box.propTypes = {
  pos: PropTypes.shape({
    x: PropTypes.number,
    y: PropTypes.number,
    z: PropTypes.number,
  }),
  shape: PropTypes.shape({
    width: PropTypes.number,
    height: PropTypes.number,
    length: PropTypes.number,
    chamfer: PropTypes.number,
  }),
};

module.exports = Box;
