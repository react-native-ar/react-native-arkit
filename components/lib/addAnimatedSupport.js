import { Animated } from 'react-native';
import React from 'react';
import get from 'lodash/get';

export default ARComponent => {
  // there is a strange issue: animatedvalues can't be child objects,
  // so we have to flatten them
  // we would need to have an Animated.ValueXYZ
  const ANIMATEABLE3D = ['position', 'eulerAngles'];
  const ARComponentAnimatedInner = Animated.createAnimatedComponent(
    class extends React.Component {
      render() {
        // unflatten
        const unflattened = {};
        ANIMATEABLE3D.forEach(key => {
          unflattened[key] = {
            x: get(this.props, `${key}_x`),
            y: get(this.props, `${key}_y`),
            z: get(this.props, `${key}_z`),
          };
        });
        return <ARComponent {...this.props} {...unflattened} />;
      }
    },
  );

  return props => {
    const flattenedProps = {};

    ANIMATEABLE3D.forEach(key => {
      flattenedProps[`${key}_x`] = get(props, [key, 'x']);
      flattenedProps[`${key}_y`] = get(props, [key, 'y']);
      flattenedProps[`${key}_z`] = get(props, [key, 'z']);
    });
    return <ARComponentAnimatedInner {...props} {...flattenedProps} />;
  };
};
