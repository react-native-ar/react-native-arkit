import Color from 'color';

export const normalizeColor = colorRaw => {
  const color = new Color(colorRaw);
  return {
    alpha: 1,
    ...color.unitObject(),
  };
};

export function parseColorInProps(props) {
  if (props && props.shader && props.shader.color) {
    return {
      ...props,
      shader: {
        ...props.shader,
        color: normalizeColor(props.shader.color),
      },
    };
  }
  return props;
}
