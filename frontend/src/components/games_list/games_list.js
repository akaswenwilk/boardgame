import React, { PureComponent } from 'react';
import axios from '../../axios.js';
import { Redirect } from "react-router-dom";

import MyContext from '../../context.js';

import GameListItem from '../games_list_item/games_list_item.js'

class GameList extends PureComponent {
  static contextType = MyContext;
  _isMounted = false;

  state = {
    games: [],
  }

  createGameHandler = () => {
    let params = {
      token: this.context.user.token
    }
    axios.post('/games', params).then(res => res.data).then(data => {
      let oldGames = this.state.games;
      let newGames = oldGames.concat(data);
      this.setState({games: newGames});
      this.context.clearErrors();
    }).catch(err => {
      let errors = err.response.data.error_message;
      this.context.addError(errors);
    });
  }

  deleteGameHandler = id => {
    let params = {
      data: {
        token: this.context.user.token
      }
    }
    axios.delete(`/games/${id}`, params).then(res => res.data).then(data => {
      let oldGames = this.state.games;
      let newGames = oldGames.filter(game => game.id !== id);
      this.setState({ games: newGames });
      this.context.clearErrors();
    }).catch(err => {
      let errors = err.response.data.error_message;
      this.context.addError(errors);
    });
  }


  setGames = () => {
    axios.get('/games').then(res => {
      if (this._isMounted) {
        this.setState({ games: res.data });
        this.context.clearErrors();
      }
    }).catch(err => {
      let errors = err.response.data.error_message;
      this.context.addError(errors);
    });
  }

  componentDidMount() {
    this._isMounted = true;

    this.setGames();
  }

  componentWillUnmount() {
    this._isMounted = false;
  }

  render() {
    if (!this.context.user) {
      return <Redirect to="/" />;
    }

    let createGame = null;
    if (this.context.user.admin) {
      createGame = (
        <button
          onClick={this.createGameHandler}
        >create game</button>
      );
    }

    let games = this.state.games.map(game => {
      return (
        <GameListItem
          deleteGameHandler={() => this.deleteGameHandler(game.id)}
          key={game.id}
          game={game} />
      );
    });

    return (
      <div>
        {createGame}
        <h1>Hello {this.context.user.email}!</h1>
        {games}
      </div>
    );
  }
}

export default GameList
