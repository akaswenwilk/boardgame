import React, { PureComponent } from 'react';
import axios from '../../axios.js';
import {
    Redirect
} from "react-router-dom";

import GameListItem from '../games_list_item/games_list_item.js'

class GameList extends PureComponent {
  state = {
    games: [],
  }

  createGameHandler = () => {
    let params = {
      token: this.props.user.token
    }
    axios.post('/games', params).then(res => {
      this.props.clearErrors();
      return res.data;
    }).then(data => {
      let oldGames = this.state.games;
      let newGames = oldGames.concat(data);
      this.setState({games: newGames});
    }).catch(err => {
      this.props.onErrorHandler(err.data.error_message);
    });
  }

  deleteGameHandler = id => {
    let params = {
      data: {
        token: this.props.user.token
      }
    }
    axios.delete(`/games/${id}`, params).then(res => {
      return res.data;
    }).then(data => {
      this.setState(state => {
        let oldGames = state.games;
        let newGames = oldGames.filter(game => game.id !== id);
        return { games: newGames };
      });
    }).catch(err => {
      this.props.onErrorHandler(err.data.error_message);
    })
  }


  setGames = () => {
    axios.get('/games').then(res => {
      this.setState({ games: res.data });
    }).catch(err => {
      this.props.onErrorHandler(err.data.error_message);
    });
  }

  componentDidMount() {
    if (this.props.user) {
      this.setGames();
    }
  }

  render() {
    if (!this.props.user) {
      return <Redirect to="/" />;
    }

    let createGame = null;
    if (this.props.user.admin) {
      createGame = (
        <button
          onClick={this.createGameHandler}
        >create game</button>
      );
    }

    let games = this.state.games.map(game => {
      return (
        <GameListItem
          deleteGameHandler={this.deleteGameHandler}
          selectGameHandler={this.props.selectGame}
          key={game.id}
          game={game} />
      );
    });

    return (
      <div>
        {createGame}
        <h1>Hello {this.props.user.email}!</h1>
        {games}
      </div>
    );
  }
}

export default GameList
