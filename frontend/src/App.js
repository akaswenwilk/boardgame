import React, { Component } from 'react';
import {
    BrowserRouter as Router,
    Switch,
    Route,
    Redirect,
} from "react-router-dom";

import MyContext from './context.js';

import Authentication from './components/authentication/authentications.js';
import GameList from './components/games_list/games_list.js';
import Logout from './components/logout/logout.js';
import Game from './components/game/game.js';
import LoadingScreen from './components/loading_screen/loading_screen.js';

class App extends Component {
  render() {
    let error = null;
    let logout = null;
    if (this.context.errors) {
      error = <p>{this.context.errors}</p>;
    }

    if (this.context.user) {
      logout = <Logout />;
    }

    let homePage = <Authentication />;
    let game = <Game />;
    let gameList = <GameList />;

    if (this.context.user) {
      homePage = <Redirect to="/games" />;
    } else {
      //game = <Redirect to="/" />;
      gameList = <Redirect to="/" />;
    }

    let loading = null;
    if (this.context.loading) {
      loading = <LoadingScreen />;
    }

    return(
      <Router>
        <div>
          {loading}
          {logout}
          {error}
          <Switch>
            <Route path="/games/:id">
              {game}
            </Route>
            <Route path="/games">
              {gameList}
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

App.contextType = MyContext;

export default App;
