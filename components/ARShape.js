import PropTypes from 'prop-types';

import { chamferMode, material } from './lib/propTypes';
import createArComponent from './lib/createArComponent';

const ARShape = createArComponent('addShape', {
  shape: PropTypes.shape({
    width: PropTypes.number,
    height: PropTypes.number,
    extrusion: PropTypes.number,
    pathSvg: PropTypes.string,
    pathFlatness: PropTypes.number,
    chamferMode,
    chamferRadius: PropTypes.number,
    chamferProfilePathSvg: PropTypes.string,
    chamferProfilePathFlatness: PropTypes.number,
  }),
  material,
});

export default ARShape;
