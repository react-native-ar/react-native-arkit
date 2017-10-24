import PropTypes from 'prop-types';

import { chamferMode } from './lib/propTypes';
import createArComponent from './lib/createArComponent';

const ARShape = createArComponent('addShape', {
  shape: PropTypes.shape({
    extrusion: PropTypes.number,
    pathSvg: PropTypes.string,
    pathFlatness: PropTypes.number,
    chamferMode,
    chamferRadius: PropTypes.number,
    chamferProfilePathSvg: PropTypes.string,
    chamferProfilePathFlatness: PropTypes.string
  })
});

module.exports = ARShape;
