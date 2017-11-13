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
  orientation,
  position,
  rotation,
  scale,
  transition,
} from './propTypes';
import { processColor, processColorInMaterial } from './parseColor';
import generateId from './generateId';

const ARGeosManager = NativeModules.ARGeosManager;

const PROP_TYPES_IMMUTABLE = {
  id: PropTypes.string,
  frame: PropTypes.string,
};
const PROP_TYPES_NODE = {
  position,
  transition,
  orientation,
  eulerAngles,
  rotation,
  scale,
};

const NODE_PROPS = keys(PROP_TYPES_NODE);
const IMMUTABLE_PROPS = keys(PROP_TYPES_IMMUTABLE);

const nodeProps = (id, props) => ({
  id,
  ...pick(props, NODE_PROPS),
});

export default (mountConfig, propTypes = {}) => {
  const allPropTypes = {
    ...PROP_TYPES_IMMUTABLE,
    ...PROP_TYPES_NODE,
    ...propTypes,
  };
  const nonNodePropKeys = keys(propTypes);

  const getNonNodeProps = props => ({
    ...pick(props, nonNodePropKeys),
    ...(props.color ? { color: processColor(props.color) } : {}),
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

      if (some(nonNodePropKeys, k => changedKeys.includes(k))) {
        update(this.identifier, props);
      } else if (some(NODE_PROPS, k => changedKeys.includes(k))) {
        ARGeosManager.updateNode(this.identifier, pick(props, NODE_PROPS));
      }
    }

    componentWillUnmount() {
      ARGeosManager.unmount(this.identifier);
    }

    render() {
      return null;
    }
  };

  ARComponent.propTypes = allPropTypes;

  return ARComponent;
};
