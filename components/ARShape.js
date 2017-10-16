import PropTypes from 'prop-types';

import createArComponent from './lib/createArComponent';

const ARShape = createArComponent('addShape', {
  shape: PropTypes.shape({
    extrusion: PropTypes.number,
    path: PropTypes.string
  })
});

module.exports = ARShape;
