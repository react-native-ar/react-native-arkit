import { Animated } from 'react-native';
import React from 'react';
import get from 'lodash/get';
import unset from 'lodash/unset';

export default ARComponent => {
  // there is a strange issue: animatedvalues can't be child objects,
  // so we have to flatten them
  // we would need to have an Animated.ValueXYZ
  const ANIMATEABLE3D = ['position', 'eulerAngles'];

  const ARComponentAnimatedInner = Animated.createAnimatedComponent(
    class extends React.PureComponent {
      render() {
        // unflatten
        const unflattened = {};
        const props = { ...this.props };
        ANIMATEABLE3D.forEach(key => {
          unflattened[key] = {
            x: get(props, `_flattened_${key}_x`),
            y: get(props, `_flattened_${key}_y`),
            z: get(props, `_flattened_${key}_z`),
          };
          unset(props, `_flattened_${key}_x`);
          unset(props, `_flattened_${key}_y`);
          unset(props, `_flattened_${key}_z`);
        });
        return <ARComponent {...props} {...unflattened} />;
      }
    },
  );

  return props => {
    const flattenedProps = {};

    ANIMATEABLE3D.forEach(key => {
      flattenedProps[`_flattened_${key}_x`] = get(props, [key, 'x']);
      flattenedProps[`_flattened_${key}_y`] = get(props, [key, 'y']);
      flattenedProps[`_flattened_${key}_z`] = get(props, [key, 'z']);
    });

    return <ARComponentAnimatedInner {...props} {...flattenedProps} />;
  };
};
