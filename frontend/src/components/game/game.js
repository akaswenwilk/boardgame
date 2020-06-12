import React, { Component } from 'react';
import axios from '../../axios.js';
import {
  Link,
  withRouter
} from "react-router-dom";

import MyContext from '../../context.js';

import PlayerBoard from '../../components/player_board/player_board.js';

class Game extends Component {
  static contextType = MyContext;

  state = {
    name: ''
  }

  componentDidMount() {
    let { id } = this.props.match.params;

    axios.get(`/games/${id}`).then(res => {
      this.context.addGame(res.data);
    }).catch(err => {
      console.log(err);
      this.context.addError(err.data.error_message);
    });
  }

  nameChangedHandler = e => {
    let name = e.target.value;
    this.setState({ name: name });
  }

  submitPlayerHandler = () => {
    if (this.state.name) {
      let { id } = this.props.match.params;

      let params = {
        token: this.context.user.token,
        name: this.state.name
      }

      axios.post(`/games/${id}/players`, params).then(res => res.data).then(data => {
        this.context.addGame(data);
      }).catch(err => this.context.addError(err.data.error_message));
    }
  }

  render() {
    let game = this.context.currentGame;

    let gameComponent = null;

    if (game) {
      let players = game.players.map(player => {
        return (
          <PlayerBoard
            key={player.id}
            player={player} />
        );
      })

      gameComponent = (
        <>
          <Link to="/games">return to games</Link>
          <h1>here's the game!</h1>
          <p>ID: {game.id}</p>
          <p>Started: {game.started.toString()}</p>
          <p>center tile holder: {game.center_tile_holder}</p>
          <p>outside tile holders: {game.outside_tile_holders}</p>
          <p>player order: {game.player_order}</p>
          <p>players: </p>
          {players}
        </>
      );
    }

    let addPlayer = (
      <div>
        <label>Name for a new player!</label>
        <input
          onChange={this.nameChangedHandler}
          type="text"
          value={this.state.name} />
        <button onClick={this.submitPlayerHandler}>Create!</button>
      </div>
    );

    if (game && (game.started || game.players.length >= 4)) {
      addPlayer = null;
    }

    return (
      <div>
        {gameComponent}
        {addPlayer}
      </div>
    );
  }
}

export default withRouter(Game);
