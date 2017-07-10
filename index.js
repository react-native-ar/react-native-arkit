//
//  index.js
//
//  Created by HippoAR on 7/9/17.
//  Copyright © 2017 HippoAR. All rights reserved.
//

import PropTypes from 'prop-types';
import React from 'react';
import { requireNativeComponent } from 'react-native';

class ARKit extends React.Component {
  render() {
    return <RCTARKit {...this.props} />;
  }
}

ARKit.propTypes = {
  debug: PropTypes.bool,
};

const RCTARKit = requireNativeComponent('RCTARKit', ARKit);

module.exports = ARKit;
