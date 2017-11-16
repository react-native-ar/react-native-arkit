import { NativeEventEmitter, NativeModules } from 'react-native';

const deviceMotionEmitter = new NativeEventEmitter(NativeModules.DeviceMotion);
let subscription;

const DeviceMotion = {
  start(callback, interval) {
    NativeModules.DeviceMotion.setUpdateInterval(interval);
    subscription = deviceMotionEmitter.addListener('MotionData', callback);
    NativeModules.DeviceMotion.startUpdates();
  },

  stop() {
    subscription.remove();
    NativeModules.DeviceMotion.stopUpdates();
  },
};

export default DeviceMotion;
