import React, { Component } from 'react';
import withAnimationFrame from '@panter/react-animation-frame';
import { round } from 'lodash';
import { NativeModules } from 'react-native';

const ARKitManager = NativeModules.ARKitManager;

const roundPoint = ({ x, y, z }, precision) => ({
  x: round(x, precision),
  y: round(y, precision),
  z: round(z, precision),
});
export default ({ throttleMs = 33 } = {}) => C =>
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
              positionProjected: roundPoint(result.point, 3),
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
