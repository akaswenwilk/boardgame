import React, { Component } from 'react';

import styles from './player_board.module.css';

import Tile from '../../components/tile/tile.js';

import MyContext from '../../context.js';

class PlayerBoard extends Component {
  static contextType = MyContext;

  activeComponent = () => {
    if (this.context.currentGame.current_player_id === this.props.player.id) {
      return true;
    } else {
      return false
    }
  }

  endingSpaces = () => {
    let player = this.props.player;
    let spaces = JSON.parse(player.player_board.ending_spaces);
    let rows = [];

    for (let i = 0; i < spaces.length; i++) {
      let tiles = [];
      let row = spaces[i].tiles;
      for (let j = 0; j < row.length; j++) {
        let tile = row[j];
        let inactive = tile.id === null
        tiles.push(
          <Tile
            inactive={inactive}
            color={tile.color}
            key={j} />
        )
      }
      rows.push(
        <div key={i}>
          {tiles}
        </div>
      )
    }

    return rows;
  }

  playingSpaces = () => {
    let player = this.props.player;
    let spaces = JSON.parse(player.player_board.playing_spaces);
    let rows = [];

    for (let i = 0; i < spaces.length; i++) {
      let tiles = [];
      let row = spaces[i];
      for (let j = 0; j < row.max_length; j++) {
        let color = 'empty';
        if (row.tiles[j]) {
          color = row.tiles[j].color;
        }
        tiles.push(
          <Tile key={j} color={color}/>
        )
      }
      let selectable = null;

      if (this.activeComponent() && this.context.possibleRows.includes(i)) {
        selectable = styles.Selectable
      }

      let result = (
        <div
          onClick={() => {
            if (selectable) {
              this.context.makeMove(i);
            }
          }}
          className={selectable}
          key={i}>
          {tiles.reverse()}
        </div>
      );

      rows.push(result)
    }

    return rows;
  }

  negativeSpaces = () => {
    let player = this.props.player;
    let board = player.player_board;

    let negativeSpaces = [];

    for (let i = 0; i < 7; i++) {
      let color = 'empty'
      let parsedNegativeSpaces = JSON.parse(board.negative_spaces);
      if (parsedNegativeSpaces[i]) {
        color = parsedNegativeSpaces[i].color
      }
      let minus;
      switch (i) {
        case 0:
        case 1:
          minus = <p>-1</p>
          break;
        case 2:
        case 3:
        case 4:
          minus = <p>-2</p>
          break;
        case 5:
        case 6:
          minus = <p>-3</p>
          break;
        default:
          minus = null;
          break;
      }
      negativeSpaces.push(
        <div
          key={i}
          onClick={() => {
            if (this.activeComponent() && this.context.selectedColor) {
              if (window.confirm('are you sure you want to place your tiles in the negative spaces?')) {
                this.context.makeMove('negative')
              }
            }
          }}
          className={styles.NegativeSpace}>
          {minus}
          <Tile className={styles.NegativeSpaceContainer} color={color} />
        </div>
      )
    }

    return negativeSpaces;
  }

  render() {
    let player = this.props.player;
    let board = player.player_board;

    return (
      <div className={this.activeComponent() ? styles.Active : styles.Board}>
        <h2>{player.name}</h2>
        <p>Points {board.points}</p>
        <div className={styles.PlayingSpaces}>
          {this.playingSpaces()}
        </div>
        <div className={styles.EndingSpaces}>
          {this.endingSpaces()}
        </div>
        <div className={styles.NegativeSpaces}>
          <h6>Negative Tiles</h6>
          {this.negativeSpaces()}
        </div>
      </div>
    );
  }
}

export default PlayerBoard;
