import { Component } from 'react';
import PropTypes from 'prop-types';
import { NativeModules } from 'react-native';
import pick from 'lodash/pick';
import {
  position,
  eulerAngles,
  rotation,
  orientation,
  material,
} from './propTypes';
import { processColorInMaterial } from './parseColor';
import generateId from './generateId';

const ARGeosManager = NativeModules.ARGeosManager;

const nodeProps = (id, props) => ({
  id,
  ...pick(props, ['position', 'eulerAngles', 'rotation', 'orientation']),
});

export default (mountConfig, propTypes = {}) => {
  let mountMethod;
  if (typeof mountConfig === 'string') {
    mountMethod = (id, props) => {
      ARGeosManager[mountConfig](
        {
          shape: props.shape,
          material: processColorInMaterial(props.material),
        },
        nodeProps(id, props),
        props.frame,
      );
    };
  } else {
    mountMethod = (id, props) => {
      mountConfig.mount(
        {
          ...pick(props, mountConfig.pick),
          material: processColorInMaterial(props.material),
        },
        nodeProps(id, props),
        props.frame,
      );
    };
  }

  const ARComponent = class extends Component {
    identifier = null;

    componentWillMount() {
      this.identifier = this.props.id || generateId();
      mountMethod(this.identifier, this.props);
    }

    componentWillUpdate(props) {
      mountMethod(this.identifier, props);
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
    position,
    eulerAngles,
    rotation,
    orientation,
    material,
    ...propTypes,
  };

  return ARComponent;
};
