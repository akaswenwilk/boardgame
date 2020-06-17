import React, { Component } from 'react';

class PlayerBoard extends Component {
  render() {
    let player = this.props.player;
    let board = player.player_board;

    return (
      <div>
        <p>Player</p>
        <p>ID: {player.id}</p>
        <p>Name: {player.name}</p>
        <p>Player's Board</p>
        <p>Points {board.points}</p>
        <p>Playing Spaces {board.playing_spaces}</p>
        <p>Ending Spaces {board.ending_spaces}</p>
        <p>Negative Spaces {board.negative_spaces}</p>
      </div>
    );
  }
}

export default PlayerBoard;
