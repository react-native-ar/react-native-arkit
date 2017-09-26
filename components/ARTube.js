//
//  ARTube.js
//
//  Created by HippoAR on 8/12/17.
//  Copyright © 2017 HippoAR. All rights reserved.
//

import PropTypes from 'prop-types';

import { NativeModules } from 'react-native';

import createArComponent from './lib/createArComponent';

const ARTube = createArComponent(NativeModules.ARTubeManager, {
  shape: PropTypes.shape({
    innerR: PropTypes.number,
    outerR: PropTypes.number,
    height: PropTypes.number,
  }),
});

module.exports = ARTube;
