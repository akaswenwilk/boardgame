import React from 'react';
import styles from './tile.module.css';

function Tile(props) {
  let stylesClasses = [styles.Tile]

  switch (props.color) {
    case 'first':
      stylesClasses.push(styles.First);
      break;
    case 'yellow':
      stylesClasses.push(styles.Yellow);
      break;
    case 'red':
      stylesClasses.push(styles.Red);
      break;
    case 'blue':
      stylesClasses.push(styles.Blue);
      break;
    case 'light_blue':
      stylesClasses.push(styles.LightBlue);
      break;
    case 'black':
      stylesClasses.push(styles.Black);
      break;
  }

  return (
    <div className={stylesClasses.join(' ')}>
    </div>
  );
}

export default Tile;
