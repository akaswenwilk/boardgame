import React, { Component } from 'react';
import styles from './center_tile_holder.module.css';
import Tile from '../../components/tile/tile.js';

class CenterTileHolder extends Component {
  render() {
    let tiles = this.props.tiles.map(tile => {
      return (
        <Tile key={tile.id} color={tile.color} />
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
