class TileRepo
  def initialize
    @model = DB[:tiles]
  end

  def populate_game(game)
    Tile::COLORS.each do |color|
      20.times do
        tile = Tile.new({
          game_id: game.id,
          color: color
        })
        id = @model.insert(**tile.attributes)
        tile.id = id

        game.tiles_in_bag << tile
      end
    end

    first_tile = Tile.new({
      game_id: game.id,
      color: Tile::FIRST
    })

    first_tile.id = @model.insert(**first_tile.attributes)
    game.center_tile_holder.tiles << first_tile
  end

  def get_first_tile(game_id)
    tile = Tile.new(@model.where(game_id: game_id, color: Tile::FIRST).first)
  end
end
