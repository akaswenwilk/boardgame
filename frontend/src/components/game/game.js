import React, { Component } from 'react';
import axios from '../../axios.js';
import _ from 'lodash';
import {
  Link,
  withRouter
} from "react-router-dom";

import MyContext from '../../context.js';
import styles from './game.module.css';
import socket from '../../socket.js';

import PlayerBoard from '../../components/player_board/player_board.js';
import CenterTileHolder from '../../components/center_tile_holder/center_tile_holder.js';
import OutsideTileHolder from '../../components/outside_tile_holder/outside_tile_holder.js';

class Game extends Component {
  static contextType = MyContext;

  state = {
    name: ''
  }

  initiateSocket = () => {
    if (!socket.gameSocket) {
      console.log('making socket');
      socket.gameSocket = new WebSocket(`ws://${process.env.REACT_APP_WEBSOCKET_DOMAIN}:8080/games/${this.props.match.params.id}/users/${this.context.user.id}`);
      socket.gameSocket.onmessage = e => {
        console.log(e.data);
        let incoming = JSON.parse(e.data);
        console.log('incoming message', incoming);
        console.log('the test', !_.isEqual(incoming, this.context.currentGame))
        if (this.context.currentGame && (!_.isEqual(incoming, this.context.currentGame))) {
          this.context.addGame(incoming);
        }
      }
    }
  }

  componentDidUpdate() {
    this.initiateSocket();
  }

  componentDidMount() {
    this.initiateSocket();

    let { id } = this.props.match.params;

    axios.get(`/games/${id}`).then(res => {
      this.context.addGame(res.data);
    }).catch(err => {
      console.log(err);
      let errors = err.response.data.error_message;
      this.context.addError(errors);
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
        socket.gameSocket.send(JSON.stringify(data));
        this.context.addGame(data);
      }).catch(err => {
        console.log(err);
        let errors = err.response.data.error_message;
        this.context.addError(errors);
      });
    }
  }

  startGameHandler = () => {
    let params = {
      token: this.context.user.token
    }

    axios.post(`/games/${this.context.currentGame.id}/start`, params).then(res => res.data).then(data => {
      socket.gameSocket.send(JSON.stringify(data));
      this.context.addGame(data);
    }).catch(err => {
      console.log(err);
      let errors = err.response.data.error_message;
      this.context.addError(errors);
    });
  }

  render() {
    let game = this.context.currentGame;

    let gameComponent = null;

    if (game) {
      let players = game.players.map((player, i) => {
        let height = {
          top: `${i * 25}%`
        }
        return (
          <div
            key={player.id}
            style={height}
            className={styles.Player}>
            <PlayerBoard
              player={player} />
          </div>
        );
      })

      let startGame = null;

      if (game.players.length > 1 && !game.started && !game.winner_name && this.context.user.admin) {
        startGame = (
          <button onClick={this.startGameHandler}>Start Game</button>
        );
      }

      if (game.started) {
        let currentPlayer = game.players.find(p => p.id === game.current_player_id);
        startGame = (
          <span>Player's Turn: {currentPlayer.name}</span>
        )
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
              selectedColor={this.context.selectedHolder === i ? this.context.selectedColor : null}
              number={i}
              tiles={holder.tiles} />
          </div>
        )
      });

      gameComponent = (
        <>
          <h1 className={styles.GameTitle}>Let's Play! {startGame}</h1>
          <div className={styles.Game}>
            <div className={styles.Board}>
              <div className={styles.Holders}>
                <div className={styles.CenterTileHolder}>
                  <CenterTileHolder
                    selectedColor={this.context.selectedHolder === 'center' ? this.context.selectedColor : null}
                    tiles={JSON.parse(game.center_tile_holder).tiles}/>
                </div>
                {outsideTileHolders}
              </div>
            </div>
            <div>
              {players}
            </div>
          </div>
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
              this.setState({name: ''});
              this.submitPlayerHandler();
            }
          }}
          type="text"
          value={this.state.name} />
        <button onClick={this.submitPlayerHandler}>Create!</button>
      </div>
    );

    if (game && (game.started || game.players.length >= 4 || game.winner_name)) {
      addPlayer = null;
    }

    let winner = null;

    if (game && game.winner_name) {
      let winningText;
      if (game.winner_name === 'tie') {
        winningText = "It's a Tie!"
      } else {
        let playerId = Number(game.winner_name);
        let winningPlayer = game.players.find(p => p.id === playerId);
        winningText = `${winningPlayer.name} won!!!`.toUpperCase();
      }

      winner = (
        <div className={styles.Winner}>
          <h1>{winningText}</h1>
        </div>
      );
    }

    return (
      <div>
        <div className={styles.AddPlayer}>
          {addPlayer}
        </div>
        <div className={styles.Return}>
          <Link className={styles.ReturnLink} to="/games">&#8592; return to games</Link>
        </div>
        <div style={{position: 'relative'}}>
          {winner}
          {gameComponent}
        </div>
      </div>
    );
  }
}

export default withRouter(Game);
