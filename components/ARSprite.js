import React, { Component } from 'react';
import withAnimationFrame from '@panter/react-animation-frame';

import { NativeModules, Animated } from 'react-native';

import { position } from './lib/propTypes';

const ARKitManager = NativeModules.ARKitManager;

const ARSprite = withAnimationFrame(
  class extends Component {
    constructor(props) {
      super(props);
      this.state = {
        zIndex: new Animated.Value(),
        pos2D: new Animated.ValueXY() // inits to zero
      };
    }
    onAnimationFrame() {
      ARKitManager.projectPoint(this.props.position).then(
        Animated.event([
          {
            x: this.state.pos2D.x,
            y: this.state.pos2D.y,
            z: this.state.zIndex
          }
        ])
      );
    }

    render() {
      return (
        <Animated.View
          style={{
            position: 'absolute',
            transform: this.state.pos2D.getTranslateTransform(),
            ...this.props.style
          }}
        >
          {this.props.children}
        </Animated.View>
      );
    }
  }
);

ARSprite.propTypes = {
  position
};

export default ARSprite;
