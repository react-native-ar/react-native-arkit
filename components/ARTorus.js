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

import createArComponent from './lib/createArComponent';

const ARTorus = createArComponent(NativeModules.ARTorusManager);

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
