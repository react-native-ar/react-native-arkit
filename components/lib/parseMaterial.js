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
  const propsWithMaps = intersection(
    Object.keys(material),
    materialPropertiesWithMaps,
  );

  return propsWithMaps.reduce((prev, curr) => {
    const { contents } = curr;

    if (!contents || (!contents.path && !contents.color)) {
      return prev;
    }

    return {
      ...prev,
      [curr]: {
        ...prev[curr],
        contents: {
          [contents.path ? 'path' : 'color']:
            contents.path || processColor(contents.color),
        },
      },
    };
  }, material);
}

export { processColor };
