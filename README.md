# react-native-arkit

[![npm version](https://img.shields.io/npm/v/react-native-arkit.svg?style=flat)](https://www.npmjs.com/package/react-native-arkit)
[![npm downloads](https://img.shields.io/npm/dm/react-native-arkit.svg?style=flat)](https://www.npmjs.com/package/react-native-arkit)

React Native binding for iOS ARKit.

**Tutorial**: [How to make an ARKit app in 5 minutes using React Native](https://medium.com/@HippoAR/how-to-make-your-own-arkit-app-in-5-minutes-using-react-native-9d7ce109a4c2)

**Sample Project**: https://github.com/HippoAR/ReactNativeARKit

**Note**: ARKit is only supported by devices with A9 or later processors (iPhone 6s/7/SE/8/X, iPad 2017/Pro) on iOS 11. You also need Xcode 9 to build the project.

There is a Slack group that anyone can join for help / support / general questions.

[**Join Slack**](https://join.slack.com/t/react-native-ar/shared_invite/enQtMjUzMzg3MjM0MTQ5LWU3Nzg2YjI4MGRjMTM1ZDBlNmIwYTE4YmM0M2U0NmY2YjBiYzQ4YzlkODExMTA0NDkwMzFhYWY4ZDE2M2Q4NGY)

## Getting started

`$ yarn add react-native-arkit`

make sure to use the latest version of yarn (>=1.x.x)

(npm does not work properly at the moment. See https://github.com/HippoAR/react-native-arkit/issues/103)


### Mostly automatic installation

`$ react-native link react-native-arkit`

! Currently automatic installation does not work as PocketSVG is missing. Follow the manual installation

### Manual installation


#### iOS

1. In XCode, in the project navigator, right click `Libraries` ➜ `Add Files to [your project's name]`
2. Go to `node_modules` ➜ add `react-native-arkit/ios/RCTARKit.xcodeproj` and `react-native-arkit/ios/PocketSVG/PocketSVG.xcodeproj`
3. In XCode, in the project navigator, select your project. Add `libRCTARKit.a` `and PocketSVG.framework` to your project's `Build Phases` ➜ `Link Binary With Libraries`
4. In Tab `General` ➜ `Embedded Binaries` ➜ `+` ➜ Add `PocketSVG.framework ios`
5. Run your project (`Cmd+R`)<


##### iOS Project configuration

These steps are mandatory regardless of doing a manual or automatic installation:

1. Give permissions for camera usage. In `Info.plist` add the following:

```
<key>NSCameraUsageDescription</key>
<string>Your message to user when the camera is accessed for the first time</string>
```
2. ARKit only runs on arm64-ready devices so the default build architecture should be set to arm64: go to `Build settings` ➜ `Build Active Architecture Only` and change the value to `Yes`.




## Usage

A simple sample React Native ARKit App

```javascript
// index.ios.js

import React, { Component } from 'react';
import { AppRegistry, View } from 'react-native';
import { ARKit } from 'react-native-arkit';

export default class ReactNativeARKit extends Component {
  render() {
    return (
      <View style={{ flex: 1 }}>
        <ARKit
          style={{ flex: 1 }}
          debug
          // enable plane detection (defaults to Horizontal)
          planeDetection={ARKit.planeDetection.Horizontal}

          // enable light estimation (defaults to true)
          lightEstimationEnabled
          // get the current lightEstimation (if enabled)
          // it fires rapidly, so better poll it from outside with
          // ARKit.getCurrentLightEstimation()
          onLightEstimation={e => console.log(e.nativeEvent)}

          // event listener for (horizontal) plane detection
          onPlaneDetected={anchor => console.log(anchor)}

          // event listener for plane update
          onPlaneUpdated={anchor => console.log(anchor)}

          // arkit sometimes removes detected planes
          onPlaneRemoved={anchor => console.log(anchor)}

          // event listeners for all anchors, see [Planes and Anchors](#planes-and-anchors)
          onAnchorDetected={anchor => console.log(anchor)}
          onAnchorUpdated={anchor => console.log(anchor)}
          onAnchorRemoved={anchor => console.log(anchor)}

          // you can detect images and will get an anchor for these images
          detectionImages={[{ resourceGroupName: 'DetectionImages' }]}


          onARKitError={console.log} // if arkit could not be initialized (e.g. missing permissions), you will get notified here
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
            text="ARKit is Cool!"
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
              scale: 1, // this is deprecated, use the scale property that is available on all 3d objects
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

AppRegistry.registerComponent('ReactNativeARKit', () => ReactNativeARKit);

```

<img src="screenshots/geometries.jpg" width="250">



### `<ARKit />`-Component

#### Props

| Prop | Type | Note |
|---|---|---|
| `debug` | `Boolean` | Debug mode will show the 3D axis and feature points detected.
| `planeDetection` | `ARKit.ARPlaneDetection.{ Horizontal \| Vertical \| None }` | ARKit plane detection. Defaults to `Horizontal`. `Vertical` is available with IOS 11.3
| `lightEstimationEnabled` | `Boolean` | ARKit light estimation (defaults to false).
| `worldAlignment` | `ARKit.ARWorldAlignment.{ Gravity \| GravityAndHeading \| Camera }` | **ARWorldAlignmentGravity** <br /> The coordinate system's y-axis is parallel to gravity, and its origin is the initial position of the device. **ARWorldAlignmentGravityAndHeading** <br /> The coordinate system's y-axis is parallel to gravity, its x- and z-axes are oriented to compass heading, and its origin is the initial position of the device. **ARWorldAlignmentCamera** <br /> The scene coordinate system is locked to match the orientation of the camera. Defaults to `ARKit.ARWorldAlignment.Gravity`.  [See](https://developer.apple.com/documentation/arkit/arworldalignment)|
| `origin` | `{position, transition}` | Usually `{0,0,0}` is where you launched the app. If you want to have a different origin, you can set it here. E.g. if you set `origin={{position: {0,-1, 0}, transition: {duration: 1}}}` the new origin will be one meter below. If you have any objects already placed, they will get moved down using the given transition. All hit-test functions or similar will report coordinates relative to that new origin as `position`. You can get the original coordinates with `positionAbsolute` in these functions |  
| `detectionImages` | `Array<DetectionImage>` | An Array of `DetectionImage` (see below), only available on IOS 11.3 |  

##### `DetectionImage`

An `DetectionImage` is an image or image resource group that should be detected by ARKit.

See https://developer.apple.com/documentation/arkit/arreferenceimage?language=objc how to add these images.

You will then receive theses images in `onAnchorDetected/onAnchorUpdated`. See also [Planes and Anchors](#planes-and-anchors) for more details.

`DetectionImage` has these properties

| Prop | Type | Notes
|---|---|---|
| `resourceGroupName` | `String` | The name of the resource group |

We probably will add the option to load images from other sources as well (PRs encouraged).

#### Events

| Event Name | Returns | Notes
|---|---|---|
| `onARKitError` | `ARKiterror` | will report whether an error occured while initializing ARKit. A common error is when the user has not allowed camera access. Another error is, if you use `worldAlignment=GravityAndHeading` and location service is turned off |
| `onLightEstimation` | `{ ambientColorTemperature, ambientIntensity }` | Light estimation on every frame. Called rapidly, better use polling. See `ARKit.getCurrentLightEstimation()`
| `onFeaturesDetected` | `{ featurePoints}` | Detected Features on every frame (currently also not throttled). Usefull to display custom dots for detected features. You can also poll this information with `ARKit.getCurrentDetectedFeaturePoints()`
| `onAnchorDetected` | `Anchor` | When an anchor (plane or image) is first detected.
| `onAnchorUpdated` | `Anchor` | When an anchor is updated
| `onAnchorRemoved` | `Anchor` | When an anchor is removed
| `onPlaneDetected` | `Anchor` | When a plane anchor is first detected.
| `onPlaneUpdated` | `Anchor` | When a detected plane is updated
| `onPlaneRemoved` | `Anchor` | When a detected plane is removed

See [Planes and Anchors](#planes-and-anchors) for Details about anchors



#### Planes and Anchors

ARKit can detect different anchors in the real world:

- `plane` horizontal and vertical planes
- `image`, image-anchors [See DetectionImage](#DetectionImage)
- face with iphone X or similar (not implemented yet)

You then will receive anchor objects in the `onAnchorDetected`, `onAnchorUpdated`, `onAnchorRemoved` callbacks on your `<ARKit />`-component.

You can use `onPlaneDetected`, `onPlaneUpdated`, `onPlaneRemoved` to only receive plane-anchors (may be deprecated later).

The `Anchor` object has the following properties:

| Property | Type | Description
|---|---|---|
| `id` | `String` | a unique id identifying the anchor |
| `type` | `String` | The type of the anchor (plane, image) |
| `position` | `{ x, y, z }` | the position of the anchor (relative to the origin) |
| `positionAbsolute` | `{ x, y, z }` | the absolute position of the anchor |
| `eulerAngles` | `{ x, y, z }` | the rotation of the plane |

If its a `plane`-anchor, it will have these additional properties:

| Property | Description
|---|---|
| `extent` | see https://developer.apple.com/documentation/arkit/arplaneanchor?language=objc |
| `center` | see https://developer.apple.com/documentation/arkit/arplaneanchor?language=objc |

`image`-Anchor:

| Property | type | Description
|---|---|---|
| `image` | `{name}` | an object with the name of the image.



### Static methods

Static Methods can directly be used on the `ARKit`-export:

```
import { ARKit } from 'react-native-arkit'

//...
const result = await ARKit.hitTestSceneObjects(point);

```

All methods return a *promise* with the result.

| Method Name | Arguments |  Notes
|---|---|---|
| `snapshot` |  |  | Take a screenshot (will save to Photo Library) |
| `snapshotCamera` |  | Take a screenshot without 3d models (will save to Photo Library) |
| `getCameraPosition` |  | Get the current position of the `ARCamera` |
| `getCamera` |  | Get all properties of the `ARCamera` |
| `getCurrentLightEstimation` |  | Get current light estimation  `{ ambientColorTemperature, ambientIntensity}` |
| `getCurrentDetectedFeaturePoints` |  | Get current detected feature points (in last current frame)  (array) |
| `focusScene` |  | Sets the scene's position/rotation to where it was when first rendered (but now relative to your device's current position/rotation) |
| `hitTestPlanes` | point, type  |  check if a plane has ben hit by point (`{x,y}`) with detection type (any of `ARKit.ARHitTestResultType`). See https://developer.apple.com/documentation/arkit/arhittestresulttype?language=objc for further information |
| `hitTestSceneObjects` | point |  check if a scene object has ben hit by point (`{x,y}`) |
| `isInitialized` | boolean | check whether arkit has been initialized (e.g. by mounting). See https://github.com/HippoAR/react-native-arkit/pull/152 for details |
| `isMounted` | boolean | check whether arkit has been mounted. See https://github.com/HippoAR/react-native-arkit/pull/152 for details |

### 3D-Components

#### General props

Most 3d object have these common properties

| Prop | Type | Description |
|---|---|---|
| `position` | `{ x, y, z }` | The object's position (y is up) |
| `scale` | Number | The scale of the object. Defaults to 1 |
| `eulerAngles` | `{ x, y, z }` | The rotation in eulerAngles |
| `rotation` | TODO | see scenkit documentation |
| `orientation` | TODO | see scenkit documentation |
| `shape` | depends on object | the shape of the object (will probably renamed to geometry in future versions)
| `material` | `{ diffuse, metalness, roughness, lightingModel, shaders }` | the material of the object |
| `transition` | `{duration: 1}` | Some property changes can be animated like in css transitions. Currently you can specify the duration (in seconds). |
| `renderingOrder` | Number | Order in which object is rendered. Usefull to place elements "behind" others, although they are nearer. |
| `categoryBitMask` | Number / bitmask | control which lights affect this object |
| `castsShadow` | `boolean` | whether this object casts shadows |
| `constraint` | `ARKit.Constraint.{ BillboardAxisAll \| BillboardAxisX \| BillboardAxisY \| BillboardAxisZ \| None }` | Constrains the node to always point to the camera |

*New experimental feature:*

You can switch properties on mount or onmount by specifying `propsOnMount` and `propsOnUnmount`.
E.g. you can scale an object on unmount:

```
<ARKit.Sphere
  position={{x:0,y:0,z:0}}
  scale={1}
  transition={{duration: 1}}
  propsOnUnmount={{
    scale: 0
  }}
/>
```

#### Material

Most objects take a material property with these sub-props:

| Prop | Type | Description |
|---|---|---|
| `diffuse` | `{ ...mapProperties }` (see below) | [diffuse](https://developer.apple.com/documentation/scenekit/scnmaterial/1462589-diffuse?language=objc)
| `specular` | `{ ...mapProperties }` (see below) | [specular](https://developer.apple.com/documentation/scenekit/scnmaterial/1462516-specular?language=objc)
| `displacement` | `{ ...mapProperties }` (see below) | [displacement](https://developer.apple.com/documentation/scenekit/scnmaterial/2867516-displacement?language=objc)
| `normal` | `{ ...mapProperties }` (see below) |  [normal](https://developer.apple.com/documentation/scenekit/scnmaterial/1462542-normal)
| `metalness` | number | metalness of the object |
| `roughness` | number | roughness of the object |
| `doubleSided` | boolean | render both sides, default is `true` |
| `litPerPixel` | boolean | calculate lighting per-pixel or vertex [litPerPixel](https://developer.apple.com/documentation/scenekit/scnmaterial/1462580-litperpixel) |
| `lightingModel` | `ARKit.LightingModel.*` | [LightingModel](https://developer.apple.com/documentation/scenekit/scnmaterial.lightingmodel) |
| `blendMode` | `ARKit.BlendMode.*` | [BlendMode](https://developer.apple.com/documentation/scenekit/scnmaterial/1462585-blendmode) |
| `fillMode` | `ARKit.FillMode.*` | [FillMode](https://developer.apple.com/documentation/scenekit/scnmaterial/2867442-fillmode)
| `shaders` | Object with keys from `ARKit.ShaderModifierEntryPoint.*` and shader strings as values | [Shader modifiers](https://developer.apple.com/documentation/scenekit/scnshadable) |
| `colorBufferWriteMask` | `ARKit.ColorMask.*` | [color mask](https://developer.apple.com/documentation/scenekit/scncolormask). Set to ARKit.ColorMask.None so that an object is transparent, but receives deferred shadows. |

Map Properties:

| Prop | Type | Description |
|---|---|---|
| `path` | string | Currently `require` is not supported, so this is an absolute link to a local resource placed for example in .xcassets |
| `color` | string | Color string, only used if path is not provided |
| `wrapS` | `ARKit.WrapMode.{ Clamp \| Repeat \| Mirror }` | [wrapS](https://developer.apple.com/documentation/scenekit/scnmaterialproperty/1395384-wraps?language=objc) |
| `wrapT` | `ARKit.WrapMode.{ Clamp \| Repeat \| Mirror }` |  [wrapT](https://developer.apple.com/documentation/scenekit/scnmaterialproperty/1395382-wrapt?language=objc) |
| `wrap` | `ARKit.WrapMode.{ Clamp \| Repeat \| Mirror }` |  Shorthand for setting both wrapS & wrapT |
| `translation` | `{ x, y, z }` | Translate the UVs, equivalent to applying a translation matrix to SceneKit's `transformContents`  |
| `rotation` | `{ angle, x, y, z }` | Rotate the UVs, equivalent to applying a rotation matrix to SceneKit's `transformContents` |
| `scale` | `{ x, y, z }` | Scale the UVs, equivalent to applying a scale matrix to SceneKit's `transformContents`  |



#### [`<ARKit.Box />`](https://developer.apple.com/documentation/scenekit/scnbox)


| Prop | Type |
|---|---|
| `shape` | `{ width, height, length, chamfer }` |

And any common object property (position, material, etc.)

#### [`<ARKit.Sphere />`](https://developer.apple.com/documentation/scenekit/scnsphere)


| Prop | Type |
|---|---|
| `shape` | `{ radius }` |



#### [`<ARKit.Cylinder />`](https://developer.apple.com/documentation/scenekit/scncylinder)


| Prop | Type |
|---|---|
| `shape` | `{ radius, height }` |

#### [`<ARKit.Cone />`](https://developer.apple.com/documentation/scenekit/scncone)


| Prop | Type |
|---|---|
| `shape` | `{ topR, bottomR, height }` |

#### [`<ARKit.Pyramid />`](https://developer.apple.com/documentation/scenekit/scnpyramid)


| Prop | Type |
|---|---|
| `shape` | `{ width, height, length }` |

#### [`<ARKit.Tube />`](https://developer.apple.com/documentation/scenekit/scntube)


| Prop | Type |
|---|---|
| `shape` | `{ innerR, outerR, height }` |

#### [`<ARKit.Torus />`](https://developer.apple.com/documentation/scenekit/scntorus)


| Prop | Type |
|---|---|
| `shape` | `{ ringR, pipeR }` |

#### [`<ARKit.Capsule />`](https://developer.apple.com/documentation/scenekit/scncapsule)


| Prop | Type |
|---|---|
| `shape` | `{ capR, height }` |

#### [`<ARKit.Plane />`](https://developer.apple.com/documentation/scenekit/scnplane)


| Prop | Type |
|---|---|
| `shape` | `{ width, height }` |

Notice: planes are veritcally aligned. If you want a horizontal plane, rotate it around the x-axis.

*Example*:

This is a horizontal plane that only receives shadows, but is invisible otherwise:

```
<ARKit.Plane
    eulerAngles={{ x: Math.PI / 2 }}
    position={floorPlane.position}
    renderingOrder={9999}
    material={{
      color: '#ffffff',
      lightingModel: ARKit.LightingModel.Constant,
      colorBufferWriteMask: ARKit.ColorMask.None,
    }}
    shape={{
      width: 100,
      height: 100,
    }}
  />
```


#### [`<ARKit.Text />`](https://developer.apple.com/documentation/scenekit/scntext)

| Prop | Type |
|---|---|
| `text` | `String` |
| `font` | `{ name, size, depth, chamfer }` |



#### `<ARKit.Model />`

SceneKit only supports `.scn` and `.dae` formats.


| Prop | Type |
|---|---|
| `model` | `{ file, node, scale, alpha }` |

Objects currently don't take material property.

#### `<ARKit.Shape />`

Creates a extruded shape by an svg path.
See https://github.com/HippoAR/react-native-arkit/pull/89 for details

| Prop | Type |
|---|---|
| `shape` | `{ pathSvg, extrusion, pathFlatness, chamferRadius, chamferProfilePathSvg, chamferProfilePathFlatness }` |



#### [`<ARKit.Light />`](https://developer.apple.com/documentation/scenekit/scnlight)

Place lights on the scene!

You might set `autoenablesDefaultLighting={false}` on The `<ARKit />` component to disable default lighting. You can use `lightEstimationEnabled` and `ARKit.getCurrentLightEstimation()` to find values for intensity and temperature. This produces much nicer results then `autoenablesDefaultLighting`.



| Prop | Type | Description |
|---|---|---|
| `position` | `{ x, y, z }` |  |
| `eulerAngles` | `{ x, y, z }` |  |
| `type` | any of `ARKit.LightType` | see [here for details](https://developer.apple.com/documentation/scenekit/scnlight.lighttype) |
| `color` | `string` | the color of the light |
| `temperature` | `Number` | The color temperature of the light |
| `intensity` | `Number` | The light intensity |
| `lightCategoryBitMask` | `Number`/`bitmask` | control which objects are lit by this light |
| `castsShadow` | `boolean` | whether to cast shadows on object |
| `shadowMode`| `ARKit.ShadowMode.* | Define the shadowmode. Set to `ARKit.ShadowMode.Deferred` to cast shadows on invisible objects (like an invisible floor plane) |



Most properties described here are also supported: https://developer.apple.com/documentation/scenekit/scnlight

This feature is new. If you experience any problem, please report an issue!


### HOCs (higher order components)

#### withProjectedPosition()

this hoc allows you to create 3D components where the position is always relative to the same point on the screen/camera, but sticks to a plane or object.

Think about a 3D cursor that can be moved across your table or a 3D cursor on a wall.

You can use the hoc like this:

```
const Cursor3D = withProjectedPosition()(({positionProjected, projectionResult}) => {
  if(!projectionResult) {
    // nothing has been hit, don't render it
    return null;
  }
  return (
    <ARKit.Sphere
      position={positionProjected}
      transition={{duration: 0.1}}
      shape={{
        radius: 0.1
        }}
    />
  )
})

```

It's recommended that you specify a transition duration (0.1s works nice), as the position gets updated rapidly, but slightly throttled.

Now you can use your 3D cursor like this:

##### Attach to a given detected horizontal plane

Given you have detected a plane with onPlaneDetected, you can make the cursor stick to that plane:

```
<Cursor3D projectPosition={{
  x: windowWidth / 2,
  y: windowHeight / 2,
  plane: "my-planeId"
  }}
/>

```

If you don't have the id, but want to place the cursor on a certain plane (e.g. the first or last one), pass a function for plane. This function will get all hit-results and you can return the one you need:

```
<Cursor3D projectPosition={{
  x: windowWidth / 2,
  y: windowHeight / 2,
  plane: (results) => results.length > 0 ? results[0] : null
  }}
/>

```

You can also add a property `onProjectedPosition` to your cursor which will be called with the hit result on every frame

It uses https://developer.apple.com/documentation/arkit/arframe/2875718-hittest with some default options. Please file an issue or send a PR if you need more control over the options here!

##### Attach to a given 3D object

You can attach the cursor on a 3D object, e.g. a non-horizontal-plane or similar:

Given there is some 3D object on your scene with `id="my-nodeId"`

```
<Cursor3D projectPosition={{
  x: windowWidth / 2,
  y: windowHeight / 2,
  node: "my-nodeId"
  }}
/>
```

Like with planes, you can select the node with a function.

E.gl you have several "walls" with ids "wall_1", "wall_2", etc.

```
<Cursor3D projectPosition={{
  x: windowWidth / 2,
  y: windowHeight / 2,
  node: results => results.find(r => r.id.startsWith('wall_')),
  }}
/>
```


It uses https://developer.apple.com/documentation/scenekit/scnscenerenderer/1522929-hittest with some default options. Please file an issue or send a PR if you need more control over the options here!


## FAQ:

#### Which permissions does this use?

- **camera access** (see section iOS Project configuration above). The user is asked for permission, as soon as you mount an `<ARKit />` component or use any of its API. If user denies access, you will get an error in `onARKitError`
- **location service**: only needed if you use `ARKit.ARWorldAlignment.GravityAndHeading`.

#### Is there an Android / ARCore version?

Not yet, but there has been a proof-of-concept: https://github.com/HippoAR/react-native-arkit/issues/14. We are looking for contributors to help backporting this proof-of-conept to react-native-arkit.

#### I have another question...

[**Join Slack!**](https://join.slack.com/t/react-native-ar/shared_invite/enQtMjUzMzg3MjM0MTQ5LWU3Nzg2YjI4MGRjMTM1ZDBlNmIwYTE4YmM0M2U0NmY2YjBiYzQ4YzlkODExMTA0NDkwMzFhYWY4ZDE2M2Q4NGY)


## Contributing

If you find a bug or would like to request a new feature, just [open an issue](https://github.com/HippoAR/react-native-arkit/issues/new). Your contributions are always welcome! Submit a pull request and see [`CONTRIBUTING.md`](CONTRIBUTING.md) for guidelines.
