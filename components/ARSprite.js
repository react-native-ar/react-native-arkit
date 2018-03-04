import {
  requireNativeComponent,
  NativeModules,
  findNodeHandle,
} from 'react-native';
import PropTypes from 'prop-types';
import React, { Component } from 'react';

import { position, transition } from './lib/propTypes';

const { ARKitSpriteViewManager } = NativeModules;

const DEFAULT_TRANSITION_DURATION = 0.05;
const ARSprite = class extends Component {
  startAnimation() {
    if (findNodeHandle(this.nativeRef)) {
      ARKitSpriteViewManager.startAnimation(findNodeHandle(this.nativeRef));
    }
  }
  stopAnimation() {
    if (findNodeHandle(this.nativeRef)) {
      ARKitSpriteViewManager.stopAnimation(findNodeHandle(this.nativeRef));
    }
  }
  componentDidUpdate(oldProps) {
    if (oldProps.disablePositionUpdate !== this.props.disablePositionUpdate)
      this.handleAnimation();
  }
  componentWillUnmount() {
    this.stopAnimation();
  }
  handleAnimation() {
    if (this.props.disablePositionUpdate) {
      this.stopAnimation();
    } else {
      this.startAnimation();
    }
  }
  render() {
    const { position, transition, ...props } = this.props;
    return (
      <RCTARKitARSprite
        ref={ref => {
          if (ref && !this.nativeRef) {
            this.nativeRef = ref;
            this.handleAnimation();
          }
        }}
        {...props}
        position3D={position}
        transitionDuration={
          transition ? transition.duration : DEFAULT_TRANSITION_DURATION
        }
        style={{ position: 'absolute' }}
      />
    );
  }
};

const RCTARKitARSprite = requireNativeComponent('RCTARKitSpriteView', null);
RCTARKitARSprite.propTypes = {
  position3D: position,
  transitionDuration: PropTypes.number,
};
ARSprite.propTypes = {
  position,
  transition,
  disablePositionUpdate: PropTypes.bool,
};

export default ARSprite;
