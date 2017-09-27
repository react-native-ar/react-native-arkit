import { View } from 'react-native';
import React, { Component } from 'react';

const ARGroup = class extends Component {
  render() {
    return <View>{this.props.children}</View>;
  }
};

module.exports = ARGroup;
