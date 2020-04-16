class TileHolderRepo
  def initialize
    @model = DB[:tile_holders]
  end

  def create_center_holder(game_id)
    @model.insert(game_id: game_id, center: true)
  end

  def add_tiles(tile_holder_id, tiles)
    tile_holder = @model.where(id: tile_holder_id)
    current_tiles = JSON(tile_holder.first[:current_tiles])
    new_tiles = current_tiles + tiles

    tile_holder.update(current_tiles: new_tiles.to_json)
  end
end
