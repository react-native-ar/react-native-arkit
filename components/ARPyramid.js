//
//  ARPyramid.js
//
//  Created by HippoAR on 8/12/17.
//  Copyright © 2017 HippoAR. All rights reserved.
//

import PropTypes from 'prop-types';

import { NativeModules } from 'react-native';

import createArComponent from './lib/createArComponent';

const ARPyramid = createArComponent(NativeModules.ARPyramidManager);

ARPyramid.propTypes = {
  pos: PropTypes.shape({
    x: PropTypes.number,
    y: PropTypes.number,
    z: PropTypes.number,
    frame: PropTypes.string,
  }),
  shape: PropTypes.shape({
    width: PropTypes.number,
    length: PropTypes.number,
    height: PropTypes.number,
    color: PropTypes.string,
  }),
};

module.exports = ARPyramid;
