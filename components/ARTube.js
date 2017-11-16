//
//  ARTube.js
//
//  Created by HippoAR on 8/12/17.
//  Copyright © 2017 HippoAR. All rights reserved.
//

import PropTypes from 'prop-types';

import { material } from './lib/propTypes';
import createArComponent from './lib/createArComponent';

const ARTube = createArComponent('addTube', {
  shape: PropTypes.shape({
    innerR: PropTypes.number,
    outerR: PropTypes.number,
    height: PropTypes.number,
  }),
  material,
});

export default ARTube;
