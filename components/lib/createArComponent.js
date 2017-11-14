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
  castsShadow,
  categoryBitMask,
  eulerAngles,
  orientation,
  position,
  renderingOrder,
  rotation,
  scale,
  transition,
} from './propTypes';
import { processColor, processColorInMaterial } from './parseColor';
import generateId from './generateId';

const { ARGeosManager } = NativeModules;

const PROP_TYPES_IMMUTABLE = {
  id: PropTypes.string,
  frame: PropTypes.string,
};
const MOUNT_UNMOUNT_ANIMATION_PROPS = {
  propsOnMount: PropTypes.any,
  propsOnUnMount: PropTypes.any,
};
const PROP_TYPES_NODE = {
  position,
  transition,
  orientation,
  eulerAngles,
  rotation,
  scale,
  categoryBitMask,
  castsShadow,
  renderingOrder,
};

const NODE_PROPS = keys(PROP_TYPES_NODE);
const IMMUTABLE_PROPS = keys(PROP_TYPES_IMMUTABLE);

const nodeProps = (id, props) => ({
  id,
  ...pick(props, NODE_PROPS),
});

const TIMERS = {};
export default (mountConfig, propTypes = {}) => {
  const allPropTypes = {
    ...MOUNT_UNMOUNT_ANIMATION_PROPS,
    ...PROP_TYPES_IMMUTABLE,
    ...PROP_TYPES_NODE,
    ...propTypes,
  };
  const nonNodePropKeys = keys(propTypes);

  const getNonNodeProps = props => ({
    ...pick(props, nonNodePropKeys),
    ...(props.color ? { color: processColor(props.color) } : {}),
    ...(props.shadowColor
      ? { shadowColor: processColor(props.shadowColor) }
      : {}),
    ...(props.material
      ? { material: processColorInMaterial(props.material) }
      : {}),
  });

  const mountFunc =
    typeof mountConfig === 'string'
      ? ARGeosManager[mountConfig]
      : mountConfig.mount;

  // this function is only called on non-node properties
  const updateFunc =
    typeof mountConfig === 'object' && mountConfig.update
      ? mountConfig.update
      : mountFunc;

  const mount = (id, props) => {
    mountFunc(getNonNodeProps(props), nodeProps(id, props), props.frame);
  };
  const update = (id, props) => {
    updateFunc(getNonNodeProps(props), nodeProps(id, props), props.frame);
  };

  const ARComponent = class extends Component {
    identifier = null;
    componentDidMount() {
      this.identifier = this.props.id || generateId();
      const { propsOnMount, ...props } = this.props;
      if (propsOnMount) {
        const {
          transition: transitionOnMount = { duration: 0 },
        } = propsOnMount;
        mount(this.identifier, { ...props, ...propsOnMount });

        this.delayed(() => {
          this.props = propsOnMount;
          this.componentWillUpdate({ ...props, transition: transitionOnMount });
        }, transitionOnMount.duration * 1000);
      } else {
        mount(this.identifier, props);
      }
    }

    componentWillUpdate(props) {
      const changedKeys = filter(
        keys(this.props),
        key => !isDeepEqual(props[key], this.props[key]),
      );

      if (isEmpty(changedKeys)) {
        return;
      }
      if (__DEV__) {
        const nonAllowedUpdates = filter(changedKeys, k =>
          IMMUTABLE_PROPS.includes(k),
        );
        if (nonAllowedUpdates.length > 0) {
          throw new Error(
            `prop can't be updated: '${nonAllowedUpdates.join(', ')}'`,
          );
        }
      }
      if (some(NODE_PROPS, k => changedKeys.includes(k))) {
        ARGeosManager.updateNode(this.identifier, pick(props, NODE_PROPS));
      }

      if (some(nonNodePropKeys, k => changedKeys.includes(k))) {
        update(this.identifier, props);
      }
    }

    componentWillUnmount() {
      const { propsOnUnmount, ...props } = this.props;
      if (propsOnUnmount) {
        const fullProps = { ...props, ...propsOnUnmount };
        const { transition: { duration = 0 } = {} } = fullProps;

        this.componentWillUpdate(fullProps);
        this.delayed(() => {
          ARGeosManager.unmount(this.identifier);
        }, duration * 1000);
      } else {
        ARGeosManager.unmount(this.identifier);
      }
    }
    /**
    do something delayed, but keep order of events per id
    * */
    delayed(callback, duration) {
      if (TIMERS[this.identifier]) {
        // timer is running, do it now, otherwise we might change order
        // e.g. it could be that an unmount  happens after a remount

        global.clearTimeout(TIMERS[this.identifier].handle);
        TIMERS[this.identifier].callback.call(this);
      }

      TIMERS[this.identifier] = {
        handle: global.setTimeout(() => {
          callback.call(this);
          delete TIMERS[this.identifier];
        }, duration),
        callback,
      };
    }

    render() {
      return null;
    }
  };

  ARComponent.propTypes = allPropTypes;

  return ARComponent;
};
