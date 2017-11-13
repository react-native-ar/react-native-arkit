import PropTypes from 'prop-types';

import createArComponent from './lib/createArComponent';
import { color, lightType } from './lib/propTypes';

const ARLight = createArComponent('addLight', {
  type: lightType,
  color,
  temperature: PropTypes.number,
  intensity: PropTypes.number,
  attenuationStartDistance: PropTypes.number,
  attenuationEndDistance: PropTypes.number,
  spotInnerAngle: PropTypes.number,
  spotOuterAngle: PropTypes.number,
  castsShadow: PropTypes.bool,
  shadowRadius: PropTypes.number,
  shadowColor: color,
  // shadowMapSize: PropTypes.number,
  shadowSampleCount: PropTypes.number,
  // shadowMode // not supported yet https://developer.apple.com/documentation/scenekit/scnlight/1522847-shadowmode
  shadowBias: PropTypes.number,
  orthographicScale: PropTypes.number,
  zFar: PropTypes.number,
  zNear: PropTypes.number,
});

module.exports = ARLight;
