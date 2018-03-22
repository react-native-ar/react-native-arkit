import { NativeModules } from 'react-native';
import { values } from 'lodash';
import PropTypes from 'prop-types';

const ARKitManager = NativeModules.ARKitManager;

const animatableNumber = PropTypes.oneOfType([
  PropTypes.number,
  PropTypes.object,
]);

export const deprecated = (propType, hint = null) => (
  props,
  propName,
  componentName,
) => {
  if (props[propName]) {
    console.warn(
      `Prop \`${propName}\` supplied to` +
        ` \`${componentName}\` is deprecated. ${hint}`,
    );
  }
  return PropTypes.checkPropTypes(
    { [propName]: propType },
    props,
    propName,
    componentName,
  );
};
export const position = PropTypes.shape({
  x: animatableNumber,
  y: animatableNumber,
  z: animatableNumber,
});

export const scale = animatableNumber;
export const categoryBitMask = PropTypes.number;
export const transition = PropTypes.shape({
  duration: PropTypes.number,
});

export const planeDetection = PropTypes.oneOf(
  values(ARKitManager.ARPlaneDetection),
);
export const eulerAngles = PropTypes.shape({
  x: animatableNumber,
  y: animatableNumber,
  z: animatableNumber,
});

export const rotation = PropTypes.shape({
  x: animatableNumber,
  y: animatableNumber,
  z: animatableNumber,
  w: animatableNumber,
});

export const orientation = PropTypes.shape({
  x: animatableNumber,
  y: animatableNumber,
  z: animatableNumber,
  w: animatableNumber,
});

export const textureTranslation = PropTypes.shape({
  x: PropTypes.number,
  y: PropTypes.number,
  z: PropTypes.number,
});

export const textureRotation = PropTypes.shape({
  angle: PropTypes.number,
  x: PropTypes.number,
  y: PropTypes.number,
  z: PropTypes.number,
});

export const textureScale = PropTypes.shape({
  x: PropTypes.number,
  y: PropTypes.number,
  z: PropTypes.number,
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
export const transparencyMode = PropTypes.oneOf(
  values(ARKitManager.TransparencyMode),
);
export const chamferMode = PropTypes.oneOf(values(ARKitManager.ChamferMode));
export const color = PropTypes.string;
export const fillMode = PropTypes.oneOf(values(ARKitManager.FillMode));

export const lightType = PropTypes.oneOf(values(ARKitManager.LightType));
export const shadowMode = PropTypes.oneOf(values(ARKitManager.ShadowMode));
export const colorBufferWriteMask = PropTypes.oneOf(
  values(ARKitManager.ColorMask),
);

export const opacity = animatableNumber;

export const constraint = PropTypes.oneOf(values(ARKitManager.Constraint));

export const wrapMode = PropTypes.oneOf(values(ARKitManager.WrapMode));

export const materialProperty = PropTypes.shape({
  path: PropTypes.string,
  color: PropTypes.string,
  intensity: PropTypes.number,
  wrapS: wrapMode,
  wrapT: wrapMode,
  wrap: wrapMode,
  translation: textureTranslation,
  scale: textureScale,
  rotation: textureRotation,
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
  transparencyMode,
  lightingModel,
  shaders,
  writesToDepthBuffer: PropTypes.bool,
  colorBufferWriteMask,
  doubleSided: PropTypes.bool,
  litPerPixel: PropTypes.bool,
  transparency: PropTypes.number,
  fillMode,
});

const detectionImage = PropTypes.shape({
  resourceGroupName: PropTypes.string,
});
export const detectionImages = PropTypes.arrayOf(detectionImage);
