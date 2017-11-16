//
//  ARModel.js
//
//  Created by HippoAR on 8/12/17.
//  Copyright © 2017 HippoAR. All rights reserved.
//

import PropTypes from 'prop-types';

import { NativeModules } from 'react-native';

import { material } from './lib/propTypes';
import createArComponent from './lib/createArComponent';

const ARModel = createArComponent(
  {
    mount: NativeModules.ARModelManager.mount,
  },
  {
    model: PropTypes.shape({
      file: PropTypes.string,
      node: PropTypes.string,
      scale: PropTypes.number,
      alpha: PropTypes.number,
    }),
    material,
  },
  ['model'],
);

export default ARModel;
