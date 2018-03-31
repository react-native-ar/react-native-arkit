//
//  ARText.js
//
//  Created by HippoAR on 8/12/17.
//  Copyright © 2017 HippoAR. All rights reserved.
//

import PropTypes from 'prop-types';

import { NativeModules } from 'react-native';

import { material } from './lib/propTypes';
import createArComponent from './lib/createArComponent';

const ARText = createArComponent(
  { mount: NativeModules.ARTextManager.mount },
  {
    text: PropTypes.string,
    font: PropTypes.shape({
      name: PropTypes.string,
      // weight: PropTypes.string,
      size: PropTypes.number,
      depth: PropTypes.number,
      chamfer: PropTypes.number
    }),
    material
  },
  ['text', 'font']
);

export default ARText;
