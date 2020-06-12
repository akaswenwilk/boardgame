import React, { Component } from 'react';
import MyContext from './context.js';

class GlobalStateProvider extends Component {
  state = {
    user: null,
    errors: null,
    currentGame: null
  }

  componentDidMount() {
    if (this.state.user === null) {
      let user = JSON.parse(window.localStorage.getItem('user'));
      if (user) {
        this.setState({ user: user });
      }
    }
  }

  addErrorHandler = errorMessage => {
    this.setState({ errors: errorMessage });
  }

  clearErrorsHandler = () => {
    this.setState({ errors: null });
  }

  addUserHandler = (user, errors = null) => {
    this.setState({ user: user, errors: errors});
  }

  addGameHandler = (game, errors = null) => {
    this.setState({ currentGame: game, errors: errors });
  }

  clearAllHandler = () => {
    this.setState({
      user: null,
      errors: null,
      currentGame: null
    });
  }

  render() {
    return (
      <MyContext.Provider
        value={{
          user: this.state.user,
          errors: this.state.errors,
          currentGame: this.state.currentGame,
          addError: this.addErrorHandler,
          clearErrors: this.clearErrorsHandler,
          addUser: this.addUserHandler,
          addGame: this.addGameHandler,
          clearAll: this.clearAllHandler,
        }}>
        {this.props.children}
      </MyContext.Provider>
    );
  }
}

export default GlobalStateProvider;
