import PropTypes from 'prop-types';
import { NativeModules } from 'react-native';
import { categoryBitMask, color, lightType, shadowMode } from './lib/propTypes';
import createArComponent from './lib/createArComponent';

const ARLight = createArComponent(
  {
    mount: NativeModules.ARGeosManager.addLight
  },
  {
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
    shadowMode,
    shadowBias: PropTypes.number,
    orthographicScale: PropTypes.number,
    zFar: PropTypes.number,
    zNear: PropTypes.number,
    lightCategoryBitMask: categoryBitMask
  }
);

export default ARLight;
