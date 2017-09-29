import React, { Component } from 'react';
import withAnimationFrame from 'react-animation-frame';

import { NativeModules, Animated } from 'react-native';

import { position } from './lib/propTypes';

const ARKitManager = NativeModules.ARKitManager;

const ARSprite = withAnimationFrame(
  class extends Component {
    identifier = null;

    constructor(props) {
      super(props);

      this.state = {
        visible: true,
        pos2D: new Animated.ValueXY(), // inits to zero
      };
    }
    onAnimationFrame() {
      ARKitManager.projectPoint(
        this.props.pos,
      ).then(({ x, y, z, distance }) => {
        this.setState({ visible: z < 1 });
        this.state.pos2D.setValue({ x, y });
      });
    }

    render() {
      if (!this.state.visible) {
        return null;
      }
      return (
        <Animated.View
          style={{
            transform: this.state.pos2D.getTranslateTransform(),
            ...this.props.style,
          }}
        >
          {this.props.children}
        </Animated.View>
      );
    }
  },
);

ARSprite.propTypes = {
  position,
};

module.exports = ARSprite;
