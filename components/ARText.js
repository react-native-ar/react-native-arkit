//
//  ARText.js
//
//  Created by HippoAR on 8/12/17.
//  Copyright © 2017 HippoAR. All rights reserved.
//

import PropTypes from 'prop-types';

import { NativeModules } from 'react-native';

import createArComponent from './lib/createArComponent';

const ARText = createArComponent(NativeModules.ARTextManager);

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
  }),
  shader: PropTypes.shape({
    color: PropTypes.string,
    metalness: PropTypes.number,
    roughness: PropTypes.number,
  }),
};

module.exports = ARText;
