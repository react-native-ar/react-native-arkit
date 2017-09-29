import { values } from 'lodash';
import PropTypes from 'prop-types';

import { NativeModules } from 'react-native';

const ARKitManager = NativeModules.ARKitManager;

export const position = PropTypes.shape({
  x: PropTypes.number,
  y: PropTypes.number,
  z: PropTypes.number,
});
export const eulerAngles = PropTypes.shape({
  x: PropTypes.number,
  y: PropTypes.number,
  z: PropTypes.number,
});

export const rotation = PropTypes.shape({
  x: PropTypes.number,
  y: PropTypes.number,
  z: PropTypes.number,
  w: PropTypes.number,
});

export const orientation = PropTypes.shape({
  x: PropTypes.number,
  y: PropTypes.number,
  z: PropTypes.number,
  w: PropTypes.number,
});

export const material = PropTypes.shape({
  color: PropTypes.string,
  metalness: PropTypes.number,
  roughness: PropTypes.number,
  lightingModel: PropTypes.oneOf(values(ARKitManager.LightingModel)),
});
