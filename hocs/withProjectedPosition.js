import React, { Component } from 'react';
import withAnimationFrame from '@panter/react-animation-frame';
import { round, isFunction } from 'lodash';
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
          projectionResult: null,
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

      onResult(result) {
        if (this._isMounted) {
          if (result) {
            this.setState({
              positionProjected: roundPoint(result.point, 3),
              projectionResult: result,
            });
          } else {
            this.setState({
              positionProjected: null,
              projectionResult: null,
            });
          }
        }
      }

      onAnimationFrame() {
        const { x, y, plane, node } = this.props.projectPosition || {};

        if (plane) {
          ARKitManager.hitTestPlanes(
            { x, y },
            ARKitManager.ARHitTestResultType.ExistingPlane,
          ).then(({ results }) => {
            const result = isFunction(plane)
              ? plane(results)
              : results.find(r => r.id === plane);
            this.onResult(result);
          });
        } else if (node) {
          ARKitManager.hitTestSceneObjects({ x, y }).then(({ results }) => {
            const result = isFunction(node)
              ? node(results)
              : results.find(r => r.id === node);
            this.onResult(result);
          });
        }
      }

      render() {
        return (
          <C
            onProjectedPosition={this.onProjectedPosition}
            positionProjected={this.state.positionProjected}
            projectionResult={this.state.projectionResult}
            {...this.props}
          />
        );
      }
    },
    throttleMs,
  );
