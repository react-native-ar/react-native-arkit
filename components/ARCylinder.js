//
//  ARCylinder.js
//
//  Created by HippoAR on 8/12/17.
//  Copyright © 2017 HippoAR. All rights reserved.
//

import PropTypes from 'prop-types';

import createArComponent from './lib/createArComponent';

const ARCylinder = createArComponent('addCylinder', {
  shape: PropTypes.shape({
    radius: PropTypes.number,
    height: PropTypes.number,
  }),
});

module.exports = ARCylinder;
