//
//  ARModel.js
//
//  Created by HippoAR on 8/12/17.
//  Copyright © 2017 HippoAR. All rights reserved.
//

import PropTypes from 'prop-types';

import { NativeModules } from 'react-native';

import createArComponent from './lib/createArComponent';
import { shaders } from './lib/propTypes';

const ARModel = createArComponent(
  {
    mount: NativeModules.ARModelManager.mount,
    pick: ['model', 'material', 'shape'],
  },
  {
    model: PropTypes.shape({
      file: PropTypes.string,
      node: PropTypes.string,
      scale: PropTypes.number,
      alpha: PropTypes.number,
    }),
    material: PropTypes.shape({
      shaders,
    }),
    shape: PropTypes.shape({
      shaders,
    }),
  },
);

module.exports = ARModel;
