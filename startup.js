import { NativeModules } from 'react-native';

const ARKitManager = NativeModules.ARKitManager;

export default () => {
  // when reloading the app, the scene should be cleared.
  // on prod, this usually does not happen, but you can reload the app in develop mode
  // without clearing, this would result in inconsistency
  ARKitManager.isInitialized().then(isInitialized => {
    console.log('was already initialized on startup', isInitialized);
    if (isInitialized) {
      ARKitManager.clearScene();
    }
  });
};
