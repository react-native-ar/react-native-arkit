//
//  ARTorus.js
//
//  Created by HippoAR on 8/12/17.
//  Copyright © 2017 HippoAR. All rights reserved.
//

import PropTypes from 'prop-types';

import { NativeModules } from 'react-native';

import createArComponent from './lib/createArComponent';

const ARTorus = createArComponent(NativeModules.ARTorusManager, {
  shape: PropTypes.shape({
    ringR: PropTypes.number,
    pipeR: PropTypes.number,
  }),
});

module.exports = ARTorus;
