//
//  ARPlane.js
//
//  Created by HippoAR on 8/12/17.
//  Copyright © 2017 HippoAR. All rights reserved.
//

import PropTypes from 'prop-types';

import createArComponent from './lib/createArComponent';

const ARPlane = createArComponent('addPlane', {
  shape: PropTypes.shape({
    width: PropTypes.number,
    height: PropTypes.number,
  }),
});

module.exports = ARPlane;
