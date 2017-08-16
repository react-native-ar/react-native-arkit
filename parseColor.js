export function parseColor(rgbaString) {
  const r = parseInt(rgbaString.substr(1, 2), 16) / 255;
  const g = parseInt(rgbaString.substr(3, 2), 16) / 255;
  const b = parseInt(rgbaString.substr(5, 2), 16) / 255;
  const a = parseInt(rgbaString.substr(7, 2), 16) / 255 || 1;
  return { r, g, b, a };
}

export function parseColorWrapper(method) {
  return (params = {}) => {
    const color = params.color && parseColor(params.color);
    return method({ ...params, ...color });
  };
}
