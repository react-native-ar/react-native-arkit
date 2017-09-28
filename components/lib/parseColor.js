import { processColor } from 'react-native';

export function parseColorInProps(props) {
  if (props && props.material && props.material.color) {
    return {
      ...props,
      material: {
        ...props.material,
        color: processColor(props.material.color),
      },
    };
  }
  return props;
}
