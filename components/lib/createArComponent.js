import { Component } from 'react';
import PropTypes from 'prop-types';

import { processColorInMaterial } from './parseColor';
import generateId from './generateId';

export default (Manager, propTypes = {}) => {
  const ARComponent = class extends Component {
    identifier = null;

    componentWillMount() {
      this.identifier = this.props.id || generateId();
      Manager.mount(
        {
          id: this.identifier,
          ...this.props,
        },
        processColorInMaterial(this.props.material),
      );
    }

    componentWillUpdate(props) {
      Manager.mount(
        {
          id: this.identifier,
          ...props,
        },
        processColorInMaterial(props.material),
      );
    }

    componentWillUnmount() {
      Manager.unmount(this.identifier);
    }

    render() {
      return null;
    }
  };

  ARComponent.propTypes = {
    pos: PropTypes.shape({
      x: PropTypes.number,
      y: PropTypes.number,
      z: PropTypes.number,
      frame: PropTypes.string,
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
