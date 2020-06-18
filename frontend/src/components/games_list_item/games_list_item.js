import React, { useContext } from 'react';
import { Link } from "react-router-dom";

import MyContext from '../../context.js';

function GameListItem(props) {
  let context = useContext(MyContext);

  let joinGame = (
    <Link to={`/games/${props.game.id}`}
    >join</Link>
  );

  if (props.game.started) {
    let user_ids = props.game.players.map(p => p.user_id);
    if (!user_ids.includes(context.user.id)) {
      joinGame = (
        <span>Game already in progress</span>
      );
    }
  }
  return(
    <div>
      {joinGame}
      <span>Game: {props.game.id}</span>
      <button onClick={props.deleteGameHandler}
      >delete</button>
    </div>
  );
}

export default GameListItem;
