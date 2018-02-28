import { processColor } from 'react-native';
import { isObject, isString, mapValues, set } from 'lodash';

// https://developer.apple.com/documentation/scenekit/scnmaterial
const propsWithMaps = ['normal', 'diffuse', 'displacement', 'specular'];

export default function processMaterial(materialOrg) {
  const material = { ...materialOrg };
  // previously it was possible to set { material: { color:'colorstring'}}... translate this to { material: { diffuse: { color: 'colorstring'}}}
  if (material.color) {
    set(material, 'diffuse.color', material.color);
  }

  return mapValues(
    material,
    (prop, key) =>
      propsWithMaps.includes(key)
        ? {
            ...(isObject(prop) ? prop : {}),
            color: processColor(
              // allow for setting a diffuse  colorstring { diffuse: 'colorstring'}
              key === 'diffuse' && isString(prop) ? prop : prop.color,
            ),
          }
        : prop,
  );
}
