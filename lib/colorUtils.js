// kudos to to https://github.com/jverhoelen/camanjs-whitebalance/blob/master/src/caman.whitebalance.js
import { NativeModules } from 'react-native';

const ARKitManager = NativeModules.ARKitManager;

export const colorTemperatureToRgb = temperature => {
  const m = global.Math;
  const temp = temperature / 100;
  let r;
  let g;
  let b;

  if (temp <= 66) {
    r = 255;
    g = m.min(m.max(99.4708025861 * m.log(temp) - 161.1195681661, 0), 255);
  } else {
    r = m.min(m.max(329.698727446 * m.pow(temp - 60, -0.1332047592), 0), 255);
    g = m.min(m.max(288.1221695283 * m.pow(temp - 60, -0.0755148492), 0), 255);
  }

  if (temp >= 66) {
    b = 255;
  } else if (temp <= 19) {
    b = 0;
  } else {
    b = temp - 10;
    b = m.min(m.max(138.5177312231 * m.log(b) - 305.0447927307, 0), 255);
  }

  return {
    r,
    g,
    b,
  };
};
export const whiteBalanceWithTemperature = ({ r, g, b }, temperature) => {
  const temperatureRgb = colorTemperatureToRgb(temperature);
  return {
    r: r * 255 / temperatureRgb.r,
    g: g * 255 / temperatureRgb.g,
    b: b * 255 / temperatureRgb.b,
  };
};
