//
//  ARTorus.js
//
//  Created by HippoAR on 8/12/17.
//  Copyright © 2017 HippoAR. All rights reserved.
//

import PropTypes from 'prop-types';

import { material } from './lib/propTypes';
import createArComponent from './lib/createArComponent';

const ARTorus = createArComponent(
  { props: { shape: { type: 'torus' } } },
  {
    shape: PropTypes.shape({
      ringR: PropTypes.number,
      pipeR: PropTypes.number
    }),
    material
  }
);

export default ARTorus;
