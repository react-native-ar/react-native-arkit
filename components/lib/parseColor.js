import Color from 'color';

export const normalizeColor = colorRaw => {
  const color = new Color(colorRaw);
  return {
    alpha: 1,
    ...color.unitObject(),
  };
};

export function parseColorInProps(props) {
  if (props && props.material && props.material.color) {
    return {
      ...props,
      material: {
        ...props.material,
        color: normalizeColor(props.material.color),
      },
    };
  }
  return props;
}
