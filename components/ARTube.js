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
import createArComponent from './lib/createArComponent';

const ARTube = createArComponent(NativeModules.ARTubeManager);

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
