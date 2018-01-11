/**
 * @fileoverview Set up the route for entire frontend using react router
 */

import * as React from 'react';
import { browserHistory, Route, Router } from 'react-router';
import Home = require('./components/home');

class App extends React.Component<{}, {}> {
  public render() {
    return (
    <Router
      history={browserHistory}
    >
      <Route path="/" component={Home} />
    </Router>
  );
  }
}

export default App;
