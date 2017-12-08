import { NativeModules } from 'react-native';

import { whiteBalanceWithTemperature } from './colorUtils';

const ARKitManager = NativeModules.ARKitManager;

const doWhiteBalance = async (colors, { includeRawColors }) => {
  const lightEstimation = await ARKitManager.getCurrentLightEstimation();

  if (!lightEstimation) {
    return colors;
  }

  return colors.map(({ color, ...p }) => ({
    color: whiteBalanceWithTemperature(
      color,
      lightEstimation.ambientColorTemperature,
    ),
    ...p,
    ...(includeRawColors ? { colorRaw: color } : {}),
  }));
};
export const pickColorsFromFile = async (
  filePath,
  {
    whiteBalance = true,
    includeRawColors = false,
    // color grabber options, currently undocumented
    range = 40,
    dimension = 4,
    flexibility = 5,
  } = {},
) => {
  const colors = await ARKitManager.pickColorsRawFromFile(filePath, {
    range,
    dimension,
    flexibility,
  });
  if (!whiteBalance) {
    return colors;
  }
  return doWhiteBalance(colors, { includeRawColors });
};
export const pickColors = async (
  {
    whiteBalance = true,
    includeRawColors = false,
    selection = null,
    // color grabber options, currently undocumented
    range = 40,
    dimension = 4,
    flexibility = 5,
  } = {},
) => {
  const colors = await ARKitManager.pickColorsRaw({
    selection,
    range,
    dimension,
    flexibility,
  });
  if (!whiteBalance) {
    return colors;
  }
  return doWhiteBalance(colors, { includeRawColors });
};
