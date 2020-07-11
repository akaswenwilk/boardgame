import React, { Component } from 'react';
import styles from './outside_tile_holder.module.css';

import MyContext from '../../context.js';

import Tile from '../../components/tile/tile.js';

class OutsideTileHolder extends Component {
  static contextType = MyContext;

  render() {
    let tiles = this.props.tiles.map(tile => {
      return (
        <span
          onClick={() => {
            if (this.context.canMakeMove()) {
              this.context.selectHolderAndColor(this.props.number, tile.color)
            }
          }}
          key={tile.id}>
          <Tile
            selected={this.props.selectedColor === tile.color}
            color={tile.color} />
        </span>
      )
    });

    return (
      <div
        className={styles.OutsideTileHolder}>
        <div className={styles.Tiles}>
          {tiles}
        </div>
      </div>
    )
  }
}

export default OutsideTileHolder;
