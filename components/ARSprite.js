import React, { Component } from 'react';
import withAnimationFrame from 'react-animation-frame';

import { Animated } from 'react-native';

import {
  StyleSheet,
  View,
  Text,
  NativeModules,
  requireNativeComponent,
} from 'react-native';

const ARKitManager = NativeModules.ARKitManager;

const ARSprite = withAnimationFrame(
  class extends Component {
    identifier = null;

    constructor(props) {
      super(props);
      this.state = {
        pos2D: new Animated.ValueXY(), // inits to zero
      };
    }
    onAnimationFrame() {
      ARKitManager.projectPoint({ x: 0, y: 0, z: 0 }).then(
        Animated.event([
          {
            x: this.state.pos2D.x,
            y: this.state.pos2D.y,
          },
        ]),
      );
    }

    render() {
      return (
        <Animated.View style={this.state.pos2D.getLayout()}>
          {this.props.children}
        </Animated.View>
      );
    }
  },
);

module.exports = ARSprite;
