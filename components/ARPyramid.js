//
//  ARPyramid.js
//
//  Created by HippoAR on 8/12/17.
//  Copyright © 2017 HippoAR. All rights reserved.
//

import PropTypes from 'prop-types';

import { material } from './lib/propTypes';
import createArComponent from './lib/createArComponent';

const ARPyramid = createArComponent('addPyramid', {
  shape: PropTypes.shape({
    width: PropTypes.number,
    length: PropTypes.number,
    height: PropTypes.number,
  }),
  material,
});

module.exports = ARPyramid;
