//
//  ARBox.js
//
//  Created by HippoAR on 8/12/17.
//  Copyright © 2017 HippoAR. All rights reserved.
//

import PropTypes from 'prop-types';

import { material } from './lib/propTypes';
import createArComponent from './lib/createArComponent';

const ARBox = createArComponent(
  { props: { shape: { type: 'box' } } },
  {
    shape: PropTypes.shape({
      width: PropTypes.number,
      height: PropTypes.number,
      length: PropTypes.number,
      chamfer: PropTypes.number
    }),
    material
  }
);

export default ARBox;
