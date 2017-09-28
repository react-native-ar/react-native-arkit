import { Component } from 'react';
import PropTypes from 'prop-types';
import { NativeModules } from 'react-native';

import { processColorInMaterial } from './parseColor';
import generateId from './generateId';

const ARGeosManager = NativeModules.ARGeosManager;

export default (method, propTypes = {}) => {
  const ARComponent = class extends Component {
    identifier = null;

    componentWillMount() {
      this.identifier = this.props.id || generateId();
      ARGeosManager[method](
        {
          shape: this.props.shape,
          text: this.props.text,
          font: this.props.font,
          material: processColorInMaterial(this.props.material),
        },
        {
          id: this.identifier,
          position: this.props.position,
        },
      );
    }

    componentWillUpdate(props) {
      ARGeosManager[method](
        {
          shape: props.shape,
          text: this.props.text,
          font: this.props.font,
          material: processColorInMaterial(props.material),
        },
        {
          id: this.identifier,
          position: props.position,
        },
      );
    }

    componentWillUnmount() {
      ARGeosManager.unmount(this.identifier);
    }

    render() {
      return null;
    }
  };

  ARComponent.propTypes = {
    frame: PropTypes.string,
    position: PropTypes.shape({
      x: PropTypes.number,
      y: PropTypes.number,
      z: PropTypes.number,
    }),
    eulerAngles: PropTypes.shape({
      x: PropTypes.number,
      y: PropTypes.number,
      z: PropTypes.number,
    }),
    rotation: PropTypes.shape({
      x: PropTypes.number,
      y: PropTypes.number,
      z: PropTypes.number,
      w: PropTypes.number,
    }),
    orientation: PropTypes.shape({
      x: PropTypes.number,
      y: PropTypes.number,
      z: PropTypes.number,
      w: PropTypes.number,
    }),

    material: PropTypes.shape({
      diffuse: PropTypes.string,
      metalness: PropTypes.number,
      roughness: PropTypes.number,
    }),
    ...propTypes,
  };

  return ARComponent;
};
