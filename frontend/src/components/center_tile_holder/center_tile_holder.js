import React, { Component } from 'react';
import styles from './center_tile_holder.module.css';
import Tile from '../../components/tile/tile.js';

import MyContext from '../../context.js';

class CenterTileHolder extends Component {
  static contextType = MyContext;

  render() {
    let tiles = this.props.tiles.map(tile => {
      let selected = false;
      if (this.props.selectedColor === tile.color) {
        selected = true;
      }

      if (this.props.selectedColor && tile.color === 'first') {
        selected = true;
      }
      return (
        <span
          onClick={() => {
            if (this.context.canMakeMove()) {
              this.context.selectHolderAndColor('center', tile.color)
            }
          }}
          key={tile.id}>
          <Tile
            selected={selected}
            color={tile.color} />
        </span>
      )
    });

    return (
      <div className={styles.CenterTileHolder}>
        {tiles}
      </div>
    )
  }
}

export default CenterTileHolder;
