//
//  index.js
//
//  Created by HippoAR on 7/9/17.
//  Copyright © 2017 HippoAR. All rights reserved.
//

import PropTypes from 'prop-types';
import React, { Component } from 'react';
import {
  StyleSheet,
  View,
  Text,
  NativeModules,
  requireNativeComponent,
} from 'react-native';
import { parseColorWrapper } from './parseColor';

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
          onPlaneDetected={this.callback('onPlaneDetected')}
          onPlaneUpdate={this.callback('onPlaneUpdate')}
          onTrackingState={this.callback('onTrackingState')}
        />
        {state}
      </View>
    );
  }

  getCameraPosition = ARKitManager.getCameraPosition;
  snapshot = ARKitManager.snapshot;
  pause = ARKitManager.pause;
  resume = ARKitManager.resume;

  addBox = parseColorWrapper(ARKitManager.addBox);
  addSphere = parseColorWrapper(ARKitManager.addSphere);
  addCylinder = parseColorWrapper(ARKitManager.addCylinder);
  addCone = parseColorWrapper(ARKitManager.addCone);
  addPyramid = parseColorWrapper(ARKitManager.addPyramid);
  addTube = parseColorWrapper(ARKitManager.addTube);
  addTorus = parseColorWrapper(ARKitManager.addTorus);
  addCapsule = parseColorWrapper(ARKitManager.addCapsule);
  addPlane = parseColorWrapper(ARKitManager.addPlane);
  addText = parseColorWrapper(ARKitManager.addText);
  addModel = ARKitManager.addModel;
  addImage = ARKitManager.addImage;

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

ARKit.propTypes = {
  debug: PropTypes.bool,
  planeDetection: PropTypes.bool,
  lightEstimation: PropTypes.bool,
  onPlaneDetected: PropTypes.func,
  onPlaneUpdate: PropTypes.func,
  onTrackingState: PropTypes.func,
};

const RCTARKit = requireNativeComponent('RCTARKit', ARKit);

module.exports = ARKit;
