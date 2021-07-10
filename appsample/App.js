import React, { Component } from 'react';
import { AppRegistry, View , NativeModules} from 'react-native';
import { ARKit } from 'react-native-arkit';
export default class App extends Component {
  constructor() {
    super();
    this.state = {
      text: "beginning text"
    }
    setTimeout(()=>{
      this.setState(()=>{
        return {text:"He's OK"}
      });
    }, 5000)
  }
  componentDidMount()  {
    this.setState(()=> {
      return {text: "Wilkimg is the best!"}
    })
    
  }
  render() {
    return (
      <View style={{ flex: 1 }}>
        <ARKit
          style={{ flex: 1 }}
          debug
          planeDetection
          // enable light estimation (defaults to true)
          lightEstimationEnabled
          // get the current lightEstimation (if enabled)
          // it fires rapidly, so better poll it from outside with
          // ARKit.getCurrentLightEstimation()
          onLightEstimation={e => console.log(e.nativeEvent)}
          onPlaneDetected={console.log} // event listener for plane detection
          onPlaneUpdate={console.log} // event listener for plane update
        >
          <ARKit.Box
            position={{ x: 0, y: 0, z: 0 }}
            shape={{ width: 0.1, height: 0.1, length: 0.1, chamfer: 0.01 }}
          />
          <ARKit.Sphere
            position={{ x: 0.2, y: 0, z: 0 }}
            shape={{ radius: 0.05 }}
          />
          <ARKit.Cylinder
            position={{ x: 0.4, y: 0, z: 0 }}
            shape={{ radius: 0.05, height: 0.1 }}
          />
          <ARKit.Cone
            position={{ x: 0, y: 0.2, z: 0 }}
            shape={{ topR: 0, bottomR: 0.05, height: 0.1 }}
          />
          <ARKit.Pyramid
            position={{ x: 0.2, y: 0.15, z: 0 }}
            shape={{ width: 0.1, height: 0.1, length: 0.1 }}
          />
          <ARKit.Tube
            position={{ x: 0.4, y: 0.2, z: 0 }}
            shape={{ innerR: 0.03, outerR: 0.05, height: 0.1 }}
          />
          <ARKit.Torus
            position={{ x: 0, y: 0.4, z: 0 }}
            shape={{ ringR: 0.06, pipeR: 0.02 }}
          />
          <ARKit.Capsule
            position={{ x: 0.2, y: 0.4, z: 0 }}
            shape={{ capR: 0.02, height: 0.06 }}
          />
          <ARKit.Plane
            position={{ x: 0.4, y: 0.4, z: 0 }}
            shape={{ width: 0.1, height: 0.1 }}
          />
          <ARKit.Text
            text={this.state.text}
            position={{ x: 0.2, y: 0.6, z: 0 }}
            font={{ size: 0.15, depth: 0.05 }}
          />
          <ARKit.Light
            position={{ x: 1, y: 3, z: 2 }}
            type={ARKit.LightType.Omni}
            color="white"
          />
          <ARKit.Light
            position={{ x: 0, y: 1, z: 0 }}
            type={ARKit.LightType.Spot}
            eulerAngles={{ x: -Math.PI / 2 }}
            spotInnerAngle={45}
            spotOuterAngle={45}
            color="green"
          />
          <ARKit.Model
            position={{ x: -0.2, y: 0, z: 0, frame: 'local' }}
            scale={0.01}
            model={{
              file: 'art.scnassets/ship.scn', // make sure you have the model file in the ios project
            }}
          />
          <ARKit.Shape
            position={{ x: -1, y: 0, z: 0 }}
            eulerAngles={{
              x: Math.PI,
            }}
            scale={0.01}
            shape={{
              // specify shape by svg! See https://github.com/HippoAR/react-native-arkit/pull/89 for details
              pathSvg: `
              <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 100 100">
                <path d="M50,30c9-22 42-24 48,0c5,40-40,40-48,65c-8-25-54-25-48-65c 6-24 39-22 48,0 z" fill="#F00" stroke="#000"/>
              </svg>`,
              pathFlatness: 0.1,
              // it's also possible to specify a chamfer profile:
              chamferRadius: 5,
              chamferProfilePathSvg: `
                <path d="M.6 94.4c.7-7 0-13 6-18.5 1.6-1.4 5.3 1 6-.8l9.6 2.3C25 70.8 20.2 63 21 56c0-1.3 2.3-1 3.5-.7 7.6 1.4 7 15.6 14.7 13.2 1-.2 1.7-1 2-2 2-5-11.3-28.8-3-30.3 2.3-.4 5.7 1.8 6.7 0l8.4 6.5c.3-.4-8-17.3-2.4-21.6 7-5.4 14 5.3 17.7 7.8 1 .8 3 2 3.8 1 6.3-10-6-8.5-3.2-19 2-8.2 18.2-2.3 20.3-3 2.4-.6 1.7-5.6 4.2-6.4"/>
              `,
              extrusion: 10, 
            }}
          />  
        </ARKit>
      </View>
    );
  }
}
