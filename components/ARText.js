//
//  ARText.js
//
//  Created by HippoAR on 8/12/17.
//  Copyright © 2017 HippoAR. All rights reserved.
//

import PropTypes from 'prop-types';
import React, { Component } from 'react';
import { NativeModules } from 'react-native';
import id from './lib/id';
import { parseColorWrapper } from '../parseColor';

const ARTextManager = NativeModules.ARTextManager;

class ARText extends Component {
  identifier = null;

  componentWillMount() {
    this.identifier = this.props.id || id();
    parseColorWrapper(ARTextManager.mount)({
      id: this.identifier,
      text: this.props.text,
      ...this.props.pos,
      ...this.props.font,
    });
  }

  componentWillReceiveProps(newProps) {
    parseColorWrapper(ARTextManager.mount)({
      id: this.identifier,
      text: newProps.text,
      ...newProps.pos,
      ...newProps.font,
    });
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
    color: PropTypes.string,
  }),
};

module.exports = ARText;
