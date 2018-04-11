import { NativeModules, processColor } from 'react-native';
import PropTypes from 'prop-types';
import React, { PureComponent, Fragment } from 'react';
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
  opacity,
  orientation,
  position,
  renderingOrder,
  rotation,
  scale,
  constraint,
  transition,
} from './propTypes';
import addAnimatedSupport from './addAnimatedSupport';
import generateId from './generateId';
import processMaterial from './processMaterial';

const DEBUG = false;

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
  opacity,
  constraint,
};

const NODE_PROPS = keys(PROP_TYPES_NODE);
const IMMUTABLE_PROPS = keys(PROP_TYPES_IMMUTABLE);

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

  const parseMaterials = props => ({
    ...props,
    ...(props.shadowColor
      ? { shadowColor: processColor(props.shadowColor) }
      : {}),
    ...(props.color ? { color: processColor(props.color) } : {}),
    ...(props.material ? { material: processMaterial(props.material) } : {}),
  });

  const getNonNodeProps = props => parseMaterials(pick(props, nonNodePropKeys));

  const mountFunc =
    typeof mountConfig === 'string'
      ? ARGeosManager[mountConfig]
      : mountConfig.mount;

  const mount = (id, props, parentId) => {
    if (DEBUG) console.log(`[${id}] [${new Date().getTime()}] mount`, props);
    return mountFunc(
      getNonNodeProps(props),
      {
        id,
        ...pick(props, NODE_PROPS),
      },
      props.frame,
      parentId,
    );
  };

  const update = (id, props) => {
    if (DEBUG) console.log(`[${id}] [${new Date().getTime()}] update`, props);
    return ARGeosManager.updateNode(id, props);
  };

  const unmount = id => {
    if (DEBUG) console.log(`[${id}] [${new Date().getTime()}] unmount`);
    return ARGeosManager.unmount(id);
  };

  const ARComponent = class extends PureComponent {
    constructor(props) {
      super(props);
      this.identifier = props.id || generateId();
    }
    identifier = null;
    componentDidMount() {
      const { propsOnMount, ...props } = this.props;
      if (propsOnMount) {
        const fullPropsOnMount = { ...props, ...propsOnMount };
        const {
          transition: transitionOnMount = { duration: 0 },
        } = fullPropsOnMount;

        this.doPendingTimers();
        this.mountWithProps(fullPropsOnMount).then(() => {
          this.props = propsOnMount;
          this.componentWillUpdate({ ...props, transition: transitionOnMount });
        });
      } else {
        this.mountWithProps(props);
      }
    }

    async mountWithProps(props) {
      return mount(this.identifier, props, this.context.arkitParentId);
    }

    componentWillUpdate(props) {
      const changedKeys = filter(
        keys(this.props),
        key => key !== 'children' && !isDeepEqual(props[key], this.props[key]),
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
            `[${this
              .identifier}] prop can't be updated: '${nonAllowedUpdates.join(
              ', ',
            )}'`,
          );
        }
      }

      if (some(changedKeys, k => nonUpdateablePropKeys.includes(k))) {
        if (DEBUG)
          console.log(
            `[${this.identifier}] need to remount node because of `,
            changedKeys,
          );
        this.mountWithProps({ ...this.props, ...props });
      } else {
        // every property is updateable
        // send only these changed property to the native part

        const propsToupdate = {
          // always inclue transition
          transition: {
            ...this.props.transition,
            ...props.transition,
          },
          ...parseMaterials(pick(props, changedKeys)),
        };
        update(this.identifier, propsToupdate).catch(() => {
          // sometimes calls are out of order, so this node has been unmounted
          // we therefore mount again

          this.mountWithProps({ ...this.props, ...props });
        });
      }
    }

    componentWillUnmount() {
      const { propsOnUnmount, ...props } = this.props;
      if (propsOnUnmount) {
        const fullProps = { ...props, ...propsOnUnmount };
        const { transition: { duration = 0 } = {} } = fullProps;

        this.componentWillUpdate(fullProps);
        this.delayed(() => {
          unmount(this.identifier);
        }, duration * 1000);
      } else {
        this.doPendingTimers();
        unmount(this.identifier);
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
    getChildContext() {
      return {
        arkitParentId: this.identifier,
      };
    }

    render() {
      return this.props.children ? (
        <Fragment>{this.props.children}</Fragment>
      ) : null;
    }
  };
  ARComponent.childContextTypes = {
    arkitParentId: PropTypes.string,
  };
  ARComponent.contextTypes = {
    arkitParentId: PropTypes.string,
  };

  const ARComponentAnimated = addAnimatedSupport(ARComponent);
  ARComponentAnimated.propTypes = allPropTypes;

  return ARComponentAnimated;
};
