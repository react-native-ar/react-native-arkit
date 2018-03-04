import { View, NativeModules } from 'react-native';
import React, { Component } from 'react';
import withAnimationFrame from '@panter/react-animation-frame';

import { position } from './lib/propTypes';

const ARKitManager = NativeModules.ARKitManager;

const ARSprite = withAnimationFrame(
  class extends Component {
    constructor(props) {
      super(props);

      this._pos2D = { x: 0, y: 0 };
    }
    setNativeProps = nativeProps => {
      this._root.setNativeProps(nativeProps);
    };
    onAnimationFrame() {
      if (this.pos)
        this.setNativeProps({
          style: {
            position: 'absolute',
            transform: [{ translateX: this.pos.x }, { translateY: this.pos.y }],
            ...this.props.style,
          },
        });
      ARKitManager.projectPoint(this.props.position).then(pos => {
        this.pos = pos;
      });
    }

    render() {
      return (
        /* eslint no-return-assign: 0 */
        <View ref={component => (this._root = component)}>
          {this.props.children}
        </View>
      );
    }
  },
);

ARSprite.propTypes = {
  position,
};

export default ARSprite;
