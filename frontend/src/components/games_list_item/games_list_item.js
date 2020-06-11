import React from 'react';
import {
    Link
} from "react-router-dom";

function GameListItem(props) {
  let joinGame = (
    <Link to={`/games/${props.game.id}`}
      onClick={() => {
        props.selectGameHandler(props.game);
      }}
    >join</Link>
  );

  if (props.game.started) {
    joinGame = (
      <span>Game already in progress</span>
    );
  }
  return(
    <div>
      {joinGame}
      <span>Game: {props.game.id}</span>
      <button
        onClick={() => {
          props.deleteGameHandler(props.game.id);
        }}
      >delete</button>
    </div>
  );
}

export default GameListItem;
