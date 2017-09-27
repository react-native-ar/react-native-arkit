import { Component } from 'react';

import { parseColorInProps } from './parseColor';
import generateId from './generateId';
import { pos, eulerAngles, rotation, orientation, material } from './propTypes';

export default (Manager, propTypes = {}) => {
  const ARComponent = class extends Component {
    identifier = null;

    componentWillMount() {
      this.identifier = this.props.id || generateId();
      Manager.mount({
        id: this.identifier,
        ...parseColorInProps(this.props),
      });
    }

    componentWillUpdate(props) {
      Manager.mount({
        id: this.identifier,
        ...parseColorInProps(props),
      });
    }

    componentWillUnmount() {
      Manager.unmount(this.identifier);
    }

    render() {
      return null;
    }
  };

  ARComponent.propTypes = {
    pos,
    eulerAngles,
    rotation,
    orientation,
    material,
    ...propTypes,
  };

  return ARComponent;
};
