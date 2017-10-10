import { NativeModules } from 'react-native';
import PropTypes from 'prop-types';
import createArComponent from './lib/createArComponent';

const ARLight = createArComponent(
  { mount: NativeModules.ARLightManager.mount, 
    pick: ['text', 'font'] },
  {
    text: PropTypes.string,
    font: PropTypes.shape({
      name: PropTypes.string,
      size: PropTypes.number,
      depth: PropTypes.number,
      chamfer: PropTypes.number,
    }),
  },
);

module.exports = ARLight;