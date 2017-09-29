import { processColor } from 'react-native';

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
