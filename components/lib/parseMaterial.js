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

  return propsToUpdate.reduce(
    (prev, curr) => ({
      ...prev,
      [curr]: {
        ...prev[curr],
        color: processColor(
          curr === 'diffuse' && typeof prev[curr] === 'string'
            ? prev[curr]
            : prev[curr].color,
        ),
      },
    }),
    material,
  );
}

export { processColor };
