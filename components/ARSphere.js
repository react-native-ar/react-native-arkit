//
//  ARSphere.js
//
//  Created by HippoAR on 8/12/17.
//  Copyright © 2017 HippoAR. All rights reserved.
//

import PropTypes from 'prop-types';

import { NativeModules } from 'react-native';

import createArComponent from './lib/createArComponent';

const ARSphere = createArComponent(NativeModules.ARSphereManager);

ARSphere.propTypes = {
  pos: PropTypes.shape({
    x: PropTypes.number,
    y: PropTypes.number,
    z: PropTypes.number,
    frame: PropTypes.string,
  }),
  shader: PropTypes.shape({
    metalness: PropTypes.number,
    roughness: PropTypes.number,
  }),
  shape: PropTypes.shape({
    radius: PropTypes.number,
    color: PropTypes.string,
  }),
};

module.exports = ARSphere;
