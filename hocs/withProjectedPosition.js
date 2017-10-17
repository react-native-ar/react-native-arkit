import React, { Component } from 'react';
import withAnimationFrame from '@panter/react-animation-frame';

import { NativeModules } from 'react-native';

const ARKitManager = NativeModules.ARKitManager;

export default ({ throttleMs = 0 } = {}) => C =>
  withAnimationFrame(
    class extends Component {
      projectionRunning = true;
      _isMounted = false;
      constructor(props) {
        super(props);
        this.state = {
          positionProjected: props.position || { x: 0, y: 0, z: 0 },
        };
        this.handleAnimation(props);
      }
      componentWillMount() {
        this._isMounted = true;
      }
      handleAnimation({ projectionEnabled }) {
        if (projectionEnabled) {
          if (!this.projectionRunning) {
            this.projectionRunning = true;
            this.props.startAnimation();
          }
        } else if (this.projectionRunning) {
          this.projectionRunning = false;
          this.props.endAnimation();
        }
      }
      componentWillUpdate({ projectionEnabled = true }) {
        this.handleAnimation({ projectionEnabled });
      }

      componentWillUnmount() {
        this._isMounted = false;
      }

      onAnimationFrame() {
        const { x, y, planeId } = this.props.projectPosition || {};

        ARKitManager.hitTestPlanes(
          { x, y },
          ARKitManager.ARHitTestResultType.ExistingPlane,
        ).then(({ results }) => {
          //  console.log(results);
          const result = results.find(r => r.anchorId === planeId);
          if (result && this._isMounted) {
            this.setState({
              positionProjected: result.point,
            });
          }
        });
      }

      render() {
        return (
          <C
            onProjectedPosition={this.onProjectedPosition}
            positionProjected={this.state.positionProjected}
            {...this.props}
          />
        );
      }
    },
    throttleMs,
  );
