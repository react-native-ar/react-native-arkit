//
//  ARCone.js
//
//  Created by HippoAR on 8/12/17.
//  Copyright © 2017 HippoAR. All rights reserved.
//

import PropTypes from 'prop-types';

import { NativeModules } from 'react-native';

import createArComponent from './lib/createArComponent';

const ARCone = createArComponent(NativeModules.ARConeManager);

ARCone.propTypes = {
  pos: PropTypes.shape({
    x: PropTypes.number,
    y: PropTypes.number,
    z: PropTypes.number,
    frame: PropTypes.string,
  }),
  shape: PropTypes.shape({
    topR: PropTypes.number,
    bottomR: PropTypes.number,
    height: PropTypes.number,
    color: PropTypes.string,
  }),
};

module.exports = ARCone;
