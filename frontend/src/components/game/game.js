import React, { Component } from 'react';
import axios from '../../axios.js';
import {
  Link,
  withRouter
} from "react-router-dom";

import MyContext from '../../context.js';
import styles from './game.module.css';

import PlayerBoard from '../../components/player_board/player_board.js';
import CenterTileHolder from '../../components/center_tile_holder/center_tile_holder.js';
import OutsideTileHolder from '../../components/outside_tile_holder/outside_tile_holder.js';

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

  startGameHandler = () => {
    let params = {
      token: this.context.user.token
    }

    axios.post(`/games/${this.context.currentGame.id}/start`, params).then(res => res.data).then(data => {
      this.context.addGame(data);
    }).catch(err => this.context.addError(err.data.error_message));
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

      let startGame = null;

      if (game.players.length > 1 && !game.started) {
        startGame = (
          <button onClick={this.startGameHandler}>Start Game</button>
        );
      }
      let outsideTileHolders = JSON.parse(game.outside_tile_holders).map((holder, i) => {
        let distanceBetween;
        switch (JSON.parse(game.outside_tile_holders).length) {
          case 5:
            distanceBetween = 72;
            break;
          case 7:
            distanceBetween = 51;
            break;
          default:
            distanceBetween = 40;
            break;
        }
        let transformDeg = distanceBetween * i;

        const transform = {
          transform: `translateX(-50%) rotate(${transformDeg}deg)`
        };
        return (
          <div
            key={i}
            style={transform}
            className={styles.OutsideTileHolder}>
            <OutsideTileHolder
              tiles={holder.tiles} />
          </div>
        )
      });

      gameComponent = (
        <>
          <Link to="/games">return to games</Link>
          <h1>here's the game! {startGame}</h1>
          <p>ID: {game.id}</p>
          <p>Started: {game.started.toString()}</p>
          <div className={styles.Holders}>
            <div className={styles.CenterTileHolder}>
              <CenterTileHolder tiles={JSON.parse(game.center_tile_holder).tiles}/>
            </div>
            {outsideTileHolders}
          </div>
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
          onKeyPress={e => {
            if (e.key === 'Enter' && this.state.name) {
              this.submitPlayerHandler();
            }
          }}
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
