import PropTypes from "prop-types";
import React, { Component } from "react";
import { NativeModules } from "react-native";
import id from "./id";
import { parseColorWrapper } from "../../parseColor";

export default Manager =>
  class extends Component {
    identifier = null;

    componentWillMount() {
      this.identifier = this.props.id || id();
      parseColorWrapper(Manager.mount)({
        id: this.identifier,
        ...this.props
      });
    }

    componentWillUpdate(newProps) {
      parseColorWrapper(Manager.mount)({
        id: this.identifier,
        ...this.props
      });
    }

    componentWillUnmount() {
      Manager.unmount(this.identifier);
    }

    render() {
      return null;
    }
  };
