export function parseColor(rgbaString) {
  const r = parseInt(rgbaString.substr(1, 2), 16) / 255;
  const g = parseInt(rgbaString.substr(3, 2), 16) / 255;
  const b = parseInt(rgbaString.substr(5, 2), 16) / 255;
  const a = parseInt(rgbaString.substr(7, 2), 16) / 255 || 1;
  return { r, g, b, a };
}

export function parseColorWrapper(method) {
  return (...params) => {
    if (!params.length) {
      return method();
    }
    if (typeof params[0] !== 'object' || !params[0].color) {
      return method(params[0]);
    }
    return method({ ...params[0], ...parseColor(params[0].color) });
  };
}
