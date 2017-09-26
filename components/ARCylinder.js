//
//  ARCylinder.js
//
//  Created by HippoAR on 8/12/17.
//  Copyright © 2017 HippoAR. All rights reserved.
//

import PropTypes from 'prop-types';

import { NativeModules } from 'react-native';

import createArComponent from './lib/createArComponent';

const ARCylinder = createArComponent(NativeModules.ARCylinderManager, {
  shape: PropTypes.shape({
    radius: PropTypes.number,
    height: PropTypes.number,
  }),
});

module.exports = ARCylinder;
