import { Component } from 'react';
import PropTypes from 'prop-types';
import filter from 'lodash/filter';
import isDeepEqual from 'fast-deep-equal';
import isEmpty from 'lodash/isEmpty';
import keys from 'lodash/keys';
import pick from 'lodash/pick';
import some from 'lodash/some';

import { NativeModules } from 'react-native';

import {
  eulerAngles,
  material,
  orientation,
  position,
  rotation,
  transition,
} from './propTypes';
import { processColorInMaterial } from './parseColor';
import generateId from './generateId';

const ARGeosManager = NativeModules.ARGeosManager;
const NODE_PROPS = [
  'position',
  'eulerAngles',
  'rotation',
  'scale',
  'orientation',
  'transition',
];
const KEYS_THAT_NEED_REMOUNT = ['material', 'shape', 'model'];

const nodeProps = (id, props) => ({
  id,
  ...pick(props, NODE_PROPS),
});

export default (mountConfig, propTypes = {}) => {
  const getShapeAndMaterialProps = props =>
    typeof mountConfig === 'string'
      ? {
          shape: props.shape,
          material: processColorInMaterial(props.material),
        }
      : {
          ...pick(props, mountConfig.pick),
          material: processColorInMaterial(props.material),
        };

  const mountFunc =
    typeof mountConfig === 'string'
      ? ARGeosManager[mountConfig]
      : mountConfig.mount;

  const mount = (id, props) => {
    mountFunc(
      getShapeAndMaterialProps(props),
      nodeProps(id, props),
      props.frame,
    );
  };

  const ARComponent = class extends Component {
    identifier = null;
    animationIsRunning = true;
    componentDidMount() {
      this.identifier = this.props.id || generateId();

      mount(this.identifier, this.props);
    }

    componentWillUpdate(props) {
      const changedKeys = filter(
        keys(this.props),
        key => !isDeepEqual(props[key], this.props[key]),
      );

      if (isEmpty(changedKeys)) {
        return;
      }

      if (some(KEYS_THAT_NEED_REMOUNT, k => changedKeys.includes(k))) {
        // remount
        // TODO: we should be able to update

        mount(this.identifier, props);
      } else {
        // always include transition
        ARGeosManager.update(
          this.identifier,
          pick(props, ['transition', ...changedKeys]),
        );
      }
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
    transition,
    eulerAngles,
    rotation,
    orientation,
    material,
    ...propTypes,
  };

  return ARComponent;
};
