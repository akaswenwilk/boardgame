import React, { Component } from 'react';
import axios from './axios.js';
import {
    BrowserRouter as Router,
    Switch,
    Route,
    Redirect,
} from "react-router-dom";

import Authentication from './components/authentication/authentications.js';
import GameList from './components/games_list/games_list.js';
import Logout from './components/logout/logout.js';
import Game from './components/game/game.js';

class App extends Component {
  state = {
    user: null,
    errors: null,
    currentGame: null,
  }

  componentDidMount() {
    if (this.state.user === null) {
      let user = window.localStorage.getItem('user')
      if (user) {
        this.setState({ user: JSON.parse(user) });
      }
    }
  }

  loginHandler = (email, password, persistentSession = false) => {
    let params = {
      email: email,
      password: password
    }

    axios.post('/users/login', params)
      .then(response => {
        let user = response.data;
        if (persistentSession) {
          window.localStorage.setItem('user', JSON.stringify(user));
        }
        this.setState({user: user, errors: null})
      })
      .catch(response => {
        let errors = response.response.data.error_message;
        this.setState({errors: errors})
      });
  }

  signupHandler = (email, password, passwordConfirmation) => {
    let params = {
      email: email,
      password: password,
      password_confirmation: passwordConfirmation
    }

    axios.post('/users', params)
      .then(response => {
        let user = response.data
        this.setState({user: user, errors: null})
      })
      .catch(response => {
        let errors = response.response.data.error_message;
        this.setState({errors: errors})
      });
  }

  errorHandler = (error) => {
    this.setState({errors: error});
  }

  clearErrors = () => {
    this.setState({errors: null});
  }

  logoutHandler = () => {
    window.localStorage.removeItem('user');
    this.setState({
      user: null,
      errors: null,
      currentGame: null
    });
  }

  setGame = (game) => {
    this.setState({currentGame: game});
  }

  render() {
    let error = null;
    let logout = null;
    if (this.state.errors) {
      error = <p>{this.state.errors}</p>;
    }

    if (this.state.user) {
      logout = <Logout onLogout={this.logoutHandler} />;
    }

    let homePage = (
      <Authentication
        loginHandler={this.loginHandler}
        signupHandler={this.signupHandler} />
    );

    if (this.state.user) {
      homePage = <Redirect to="/games" />;
    }


    return(
      <Router>
        <div>
          {logout}
          {error}
          <Switch>
            <Route path="/games/:id">
              <Game
                onErrorHandler={this.errorHandler}
                clearErrors={this.clearErrors}
                game={this.state.currentGame}/>
            </Route>
            <Route path="/games">
              <GameList
                onErrorHandler={this.errorHandler}
                selectGame={this.setGame}
                clearErrors={this.clearErrors}
                user={this.state.user} />
            </Route>
            <Route path="/">
              {homePage}
            </Route>
          </Switch>
        </div>
      </Router>
    )
  }
}

export default App;
