//
//  ARModel.js
//
//  Created by HippoAR on 8/12/17.
//  Copyright © 2017 HippoAR. All rights reserved.
//

import PropTypes from 'prop-types';

import { NativeModules } from 'react-native';

import createArComponent from './lib/createArComponent';

const ARModel = createArComponent(NativeModules.ARModelManager);

ARModel.propTypes = {
  pos: PropTypes.shape({
    x: PropTypes.number,
    y: PropTypes.number,
    z: PropTypes.number,
    angle: PropTypes.number,
    frame: PropTypes.string,
  }),
  shader: PropTypes.shape({
    metalness: PropTypes.number,
    roughness: PropTypes.number,
  }),
  model: PropTypes.shape({
    file: PropTypes.string,
    node: PropTypes.string,
    scale: PropTypes.number,
  }),
};

module.exports = ARModel;
