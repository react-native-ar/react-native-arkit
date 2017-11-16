import { Component } from 'react';
import { NativeModules } from 'react-native';
import PropTypes from 'prop-types';
import filter from 'lodash/filter';
import isDeepEqual from 'fast-deep-equal';
import isEmpty from 'lodash/isEmpty';
import keys from 'lodash/keys';
import pick from 'lodash/pick';
import some from 'lodash/some';

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
const DEBUG = false;
const TIMERS = {};

/**
mountConfig,
propTypes,
nonUpdateablePropKeys: if a prop key is in this list,
the property will be updated on scenekit, instead of beeing remounted.

this excludes at the moment: model, font, text, (???)
* */
export default (mountConfig, propTypes = {}, nonUpdateablePropKeys = []) => {
  const allPropTypes = {
    ...MOUNT_UNMOUNT_ANIMATION_PROPS,
    ...PROP_TYPES_IMMUTABLE,
    ...PROP_TYPES_NODE,
    ...propTypes,
  };
  // any custom props (material, shape, ...)
  const nonNodePropKeys = keys(propTypes);

  const processColors = props => ({
    ...props,
    ...(props.color ? { color: processColor(props.color) } : {}),
    ...(props.shadowColor
      ? { shadowColor: processColor(props.shadowColor) }
      : {}),
    ...(props.material
      ? { material: processColorInMaterial(props.material) }
      : {}),
  });

  const getNonNodeProps = props => ({
    ...pick(props, nonNodePropKeys),
    ...processColors(props),
  });

  const mountFunc =
    typeof mountConfig === 'string'
      ? ARGeosManager[mountConfig]
      : mountConfig.mount;

  const mount = (id, props) => {
    mountFunc(
      getNonNodeProps(props),
      {
        id,
        ...pick(props, NODE_PROPS),
      },
      props.frame,
    );
  };

  const ARComponent = class extends Component {
    identifier = null;
    componentDidMount() {
      this.identifier = this.props.id || generateId();
      const { propsOnMount, ...props } = this.props;
      if (propsOnMount) {
        const fullPropsOnMount = { ...props, ...propsOnMount };
        const {
          transition: transitionOnMount = { duration: 0 },
        } = fullPropsOnMount;
        if (DEBUG) console.log('mount', fullPropsOnMount);
        this.doPendingTimers();
        mount(this.identifier, fullPropsOnMount);

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

      if (some(changedKeys, k => nonUpdateablePropKeys.includes(k))) {
        if (DEBUG) console.log('need to remount node because of ', changedKeys);
        mount(this.identifier, { ...this.props, ...props });
      } else {
        // every property is updateable
        // send only these changed property to the native part

        const propsToupdate = {
          // always inclue transition
          transition: {
            ...this.props.transition,
            ...props.transition,
          },
          ...processColors(pick(props, changedKeys)),
        };

        if (DEBUG) console.log('update node', propsToupdate);
        ARGeosManager.updateNode(this.identifier, propsToupdate);
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
        this.doPendingTimers();
        ARGeosManager.unmount(this.identifier);
      }
    }
    /**
    do something delayed, but keep order of events per id
    * */
    delayed(callback, duration) {
      this.doPendingTimers();
      TIMERS[this.identifier] = {
        handle: global.setTimeout(() => {
          callback.call(this);
          delete TIMERS[this.identifier];
        }, duration),
        callback,
      };
    }

    doPendingTimers() {
      if (TIMERS[this.identifier]) {
        // timer is running, do it now, otherwise we might change order
        // e.g. it could be that an unmount  happens after a remount
        global.clearTimeout(TIMERS[this.identifier].handle);
        TIMERS[this.identifier].callback.call(this);
        delete TIMERS[this.identifier];
      }
    }

    render() {
      return null;
    }
  };

  ARComponent.propTypes = allPropTypes;

  return ARComponent;
};
