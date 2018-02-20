import { NativeModules } from 'react-native';
import { values } from 'lodash';
import PropTypes from 'prop-types';

const ARKitManager = NativeModules.ARKitManager;

export const position = PropTypes.shape({
  x: PropTypes.oneOfType([PropTypes.number, PropTypes.object]),
  y: PropTypes.oneOfType([PropTypes.number, PropTypes.object]),
  z: PropTypes.oneOfType([PropTypes.number, PropTypes.object]),
});

export const scale = PropTypes.number;
export const categoryBitMask = PropTypes.number;
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

export const castsShadow = PropTypes.bool;
export const renderingOrder = PropTypes.number;
export const blendMode = PropTypes.oneOf(values(ARKitManager.BlendMode));
export const chamferMode = PropTypes.oneOf(values(ARKitManager.ChamferMode));
export const color = PropTypes.string;
export const fillMode = PropTypes.oneOf(values(ARKitManager.FillMode));

export const lightType = PropTypes.oneOf(values(ARKitManager.LightType));
export const shadowMode = PropTypes.oneOf(values(ARKitManager.ShadowMode));
export const colorBufferWriteMask = PropTypes.oneOf(
  values(ARKitManager.ColorMask),
);

export const opacity = PropTypes.number;

export const materialProperty = PropTypes.shape({
  path: PropTypes.string,
  color: PropTypes.string,
  intensity: PropTypes.number,
});

export const material = PropTypes.shape({
  color,
  normal: materialProperty,
  specular: materialProperty,
  displacement: materialProperty,
  diffuse: PropTypes.oneOfType([PropTypes.string, materialProperty]),
  metalness: PropTypes.number,
  roughness: PropTypes.number,
  blendMode,
  lightingModel,
  shaders,
  writesToDepthBuffer: PropTypes.bool,
  colorBufferWriteMask,
  doubleSided: PropTypes.bool,
  litPerPixel: PropTypes.bool,
  transparency: PropTypes.number,
  fillMode,
});
