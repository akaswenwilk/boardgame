import React, { useContext } from 'react';
import { Link } from "react-router-dom";

import MyContext from '../../context.js';

import styles from './games_list_item.module.css';

function GameListItem(props) {
  let context = useContext(MyContext);

  let joinGame = (
    <Link
      className={styles.JoinLink}
      to={`/games/${props.game.id}`}
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

  let deleteButton = null;

  if (context.user.admin) {
    deleteButton = (
      <button
        className={styles.Delete}
        onClick={props.deleteGameHandler}
      >delete</button>
    );
  }

  return(
    <div className={styles.Item}>
      <span className={styles.Join}>
        {joinGame}
      </span>
      <span>Game: {props.game.id}</span>
      {deleteButton}
    </div>
  );
}

export default GameListItem;
