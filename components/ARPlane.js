//
//  ARPlane.js
//
//  Created by HippoAR on 8/12/17.
//  Copyright © 2017 HippoAR. All rights reserved.
//

import PropTypes from 'prop-types';

import { material } from './lib/propTypes';
import createArComponent from './lib/createArComponent';

const ARPlane = createArComponent('addPlane', {
  shape: PropTypes.shape({
    width: PropTypes.number,
    height: PropTypes.number,
    cornerRadius: PropTypes.number,
    cornerSegmentCount: PropTypes.number,
    widthSegmentCount: PropTypes.number,
    heightSegmentCount: PropTypes.number,
  }),
  material,
});

export default ARPlane;
