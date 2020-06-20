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
    default:
      stylesClasses.push(styles.Empty);
      break;
  }

  if (props.inactive) {
    stylesClasses.push(styles.Inactive);
  }

  if (props.selected) {
    stylesClasses.push(styles.Selected);
  }

  return (
    <div className={stylesClasses.join(' ')}>
    </div>
  );
}

export default Tile;
