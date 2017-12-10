//
//  index.js
//
//  Created by HippoAR on 7/9/17.
//  Copyright © 2017 HippoAR. All rights reserved.
//

import {
  StyleSheet,
  View,
  Text,
  NativeModules,
  requireNativeComponent,
} from 'react-native';
import PropTypes from 'prop-types';
import React, { Component } from 'react';

import { pickColors, pickColorsFromFile } from './lib/pickColors';
import generateId from './components/lib/generateId';

const ARKitManager = NativeModules.ARKitManager;

const TRACKING_STATES = ['NOT_AVAILABLE', 'LIMITED', 'NORMAL'];

const TRACKING_REASONS = [
  'NONE',
  'INITIALIZING',
  'EXCESSIVE_MOTION',
  'INSUFFICIENT_FEATURES',
];
const TRACKING_STATES_COLOR = ['red', 'orange', 'green'];

class ARKit extends Component {
  state = {
    state: 0,
    reason: 0,
    floor: null,
  };

  componentDidMount() {
    ARKitManager.resume();
  }

  componentWillUnmount() {
    ARKitManager.pause();
  }

  render(AR = RCTARKit) {
    let state = null;
    if (this.props.debug) {
      state = (
        <View style={styles.statePanel}>
          <View
            style={[
              styles.stateIcon,
              { backgroundColor: TRACKING_STATES_COLOR[this.state.state] },
            ]}
          />
          <Text style={styles.stateText}>
            {TRACKING_REASONS[this.state.reason] || this.state.reason}
            {this.state.floor && ` (${this.state.floor})`}
          </Text>
        </View>
      );
    }
    return (
      <View style={this.props.style}>
        <AR
          {...this.props}
          onTapOnPlaneUsingExtent={this.callback('onTapOnPlaneUsingExtent')}
          onTapOnPlaneNoExtent={this.callback('onTapOnPlaneNoExtent')}
          onPlaneDetected={this.callback('onPlaneDetected')}
          onPlaneUpdate={this.callback('onPlaneUpdate')}
          onTrackingState={this.callback('onTrackingState')}
          onEvent={this._onEvent}
        />
        {state}
      </View>
    );
  }

  _onTrackingState = ({
    state = this.state.state,
    reason = this.state.reason,
    floor,
  }) => {
    if (this.props.onTrackingState) {
      this.props.onTrackingState({
        state: TRACKING_STATES[state] || state,
        reason: TRACKING_REASONS[reason] || reason,
        floor,
      });
    }

    if (this.props.debug) {
      this.setState({
        state,
        reason,
        floor: floor ? floor.toFixed(2) : this.state.floor,
      });
    }
  };

  _onEvent = event => {
    let eventName = event.nativeEvent.event;
    if (!eventName) {
      return;
    }
    eventName = eventName.charAt(0).toUpperCase() + eventName.slice(1);
    const eventListener = this.props[`on${eventName}`];
    if (eventListener) {
      eventListener(event.nativeEvent);
    }
  };

  callback(name) {
    return event => {
      if (this[`_${name}`]) {
        this[`_${name}`](event.nativeEvent);
        return;
      }
      if (!this.props[name]) {
        return;
      }
      this.props[name](event.nativeEvent);
    };
  }
}

const styles = StyleSheet.create({
  statePanel: {
    position: 'absolute',
    top: 30,
    left: 10,
    height: 20,
    borderRadius: 10,
    padding: 4,
    backgroundColor: 'black',
    flexDirection: 'row',
  },
  stateIcon: {
    width: 12,
    height: 12,
    borderRadius: 6,
    marginRight: 4,
  },
  stateText: {
    color: 'white',
    fontSize: 10,
    height: 12,
  },
});

// copy all ARKitManager properties to ARKit
Object.keys(ARKitManager).forEach(key => {
  ARKit[key] = ARKitManager[key];
});

const addDefaultsToSnapShotFunc = funcName => ({
  target = 'cameraRoll',
  format = 'png',
}) => ARKitManager[funcName]({ target, format });

ARKit.snapshot = addDefaultsToSnapShotFunc('snapshot');
ARKit.snapshotCamera = addDefaultsToSnapShotFunc('snapshotCamera');

ARKit.exportModel = presetId => {
  const id = presetId || generateId();
  const property = { id };
  return ARKitManager.exportModel(property).then(result => ({ ...result, id }));
};

ARKit.pickColors = pickColors;
ARKit.pickColorsFromFile = pickColorsFromFile;
ARKit.propTypes = {
  debug: PropTypes.bool,
  planeDetection: PropTypes.bool,
  lightEstimationEnabled: PropTypes.bool,
  autoenablesDefaultLighting: PropTypes.bool,
  worldAlignment: PropTypes.number,
  onPlaneDetected: PropTypes.func,
  onFeaturesDetected: PropTypes.func,
  // onLightEstimation is called rapidly, better poll with
  // ARKit.getCurrentLightEstimation()
  onLightEstimation: PropTypes.func,
  onPlaneUpdate: PropTypes.func,
  onTrackingState: PropTypes.func,
  onTapOnPlaneUsingExtent: PropTypes.func,
  onTapOnPlaneNoExtent: PropTypes.func,
  onEvent: PropTypes.func,
};

const RCTARKit = requireNativeComponent('RCTARKit', ARKit);

export default ARKit;
