//
//  ARImage.js
//
//  Created by HippoAR on 8/12/17.
//  Copyright © 2017 HippoAR. All rights reserved.
//

import PropTypes from 'prop-types';

import { NativeModules } from 'react-native';

import { material } from './lib/propTypes';
import createArComponent from './lib/createArComponent';

const ARImage = createArComponent(
  { mount: NativeModules.ARImageManager.mount, pick: ['id'] },
  {
    imageUrl: PropTypes.string,
    material
  },
  []
);

export default ARImage;
