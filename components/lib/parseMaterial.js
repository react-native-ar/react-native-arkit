import { processColor } from 'react-native';
import { intersection } from 'lodash';

// https://developer.apple.com/documentation/scenekit/scnmaterial
const materialPropertiesWithMaps = [
  'normal',
  'diffuse',
  'displacement',
  'specular',
];

export function processMaterialPropertyContents(material) {
  const propsToUpdate = intersection(
    Object.keys(material),
    materialPropertiesWithMaps,
  );
  // legacy support for old diffuse.color
  const color =
    typeof material.diffuse === 'string' ? material.diffuse : undefined;

  return propsToUpdate.reduce(
    (prev, curr) => ({
      ...prev,
      [curr]: {
        ...prev[curr],
        color: processColor(color || prev[curr].color),
      },
    }),
    material,
  );
}

export { processColor };
