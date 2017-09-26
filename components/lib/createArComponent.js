import { Component } from 'react';

import { parseColorWrapper } from '../../parseColor';
import generateId from './generateId';

export default Manager =>
  class extends Component {
    identifier = null;

    componentWillMount() {
      this.identifier = this.props.id || generateId();
      parseColorWrapper(Manager.mount)({
        id: this.identifier,
        ...this.props,
      });
    }

    componentWillUpdate() {
      parseColorWrapper(Manager.mount)({
        id: this.identifier,
        ...this.props,
      });
    }

    componentWillUnmount() {
      Manager.unmount(this.identifier);
    }

    render() {
      return null;
    }
  };
