import { values } from 'lodash';
import PropTypes from 'prop-types';

import { NativeModules } from 'react-native';

const ARKitManager = NativeModules.ARKitManager;

export const position = PropTypes.shape({
  x: PropTypes.number,
  y: PropTypes.number,
  z: PropTypes.number,
});
export const transition = PropTypes.shape({
  duration: PropTypes.number,
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

export const shaders = PropTypes.shape({
  [ARKitManager.ShaderModifierEntryPoint.Geometry]: PropTypes.string,
  [ARKitManager.ShaderModifierEntryPoint.Surface]: PropTypes.string,
  [ARKitManager.ShaderModifierEntryPoint.LightingModel]: PropTypes.string,
  [ARKitManager.ShaderModifierEntryPoint.Fragment]: PropTypes.string,
});

export const lightingModel = PropTypes.oneOf(
  values(ARKitManager.LightingModel),
);

export const blendMode = PropTypes.oneOf(values(ARKitManager.BlendMode));

export const material = PropTypes.shape({
  color: PropTypes.string,
  metalness: PropTypes.number,
  roughness: PropTypes.number,
  blendMode,
  lightingModel,
  shaders,
});
