import { Component } from 'react';

import { parseColorInProps } from './parseColor';
import generateId from './generateId';

export default Manager =>
  class extends Component {
    identifier = null;

    componentWillMount() {
      this.identifier = this.props.id || generateId();
      Manager.mount({
        id: this.identifier,
        ...parseColorInProps(this.props),
      });
    }

    componentWillUpdate() {
      Manager.mount({
        id: this.identifier,
        ...parseColorInProps(this.props),
      });
    }

    componentWillUnmount() {
      Manager.unmount(this.identifier);
    }

    render() {
      return null;
    }
  };
