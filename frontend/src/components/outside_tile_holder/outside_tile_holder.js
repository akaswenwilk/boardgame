import React, { Component } from 'react';
import styles from './outside_tile_holder.module.css';

import Tile from '../../components/tile/tile.js';

class OutsideTileHolder extends Component {
  render() {
    let tiles = this.props.tiles.map(tile => {
      return (
        <Tile
          key={tile.id}
          color={tile.color} />
      )
    });

    return (
      <div className={styles.OutsideTileHolder}>
        {tiles}
      </div>
    )
  }
}

export default OutsideTileHolder;
