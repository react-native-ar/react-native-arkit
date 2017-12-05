import { processColor } from 'react-native';
import { intersection } from 'lodash';

// https://developer.apple.com/documentation/scenekit/scnmaterial
const materialPropertiesWithMaps = [
  'normal',
  'diffuse',
  'displacement',
  'specular',
];

/* eslint import/prefer-default-export: 0 */
export function processColorInMaterial(material) {
  if (!material) {
    return material;
  }

  if (!material.diffuse && !material.color) {
    return material;
  }

  return {
    ...material,
    diffuse: processColor(material.diffuse || material.color),
  };
}

export function processMaterialPropertyContents(material) {
  const propsToUpdate = intersection(
    Object.keys(material),
    materialPropertiesWithMaps,
  );
  // legacy support for old diffuse.color
  const color =
    typeof material.diffuse === 'string' || material.color
      ? material.diffuse || material.color
      : undefined;

  return propsToUpdate.reduce(
    (prev, curr) => ({
      ...prev,
      [curr]: {
        ...prev[curr],
        color: color ? processColor(color) : processColor(prev[curr].color),
      },
    }),
    material,
  );
}

export { processColor };
