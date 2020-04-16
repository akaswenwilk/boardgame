class GameService
  def create
    game_id = game_repo.create
    tile_repo.populate_game(game_id)
    center_holder_id = tile_holder_repo.create_center_holder(game_id)
    first_tile = tile_repo.get_first_tile(game_id)
    tile_holder_repo.add_tiles(center_holder_id, [first_tile])

    game_id
  end

  private

  def game_repo
    @game_repo ||= GameRepo.new
  end

  def tile_repo
    @tile_repo ||= TileRepo.new
  end

  def tile_holder_repo
    @tile_holder_repo ||= TileHolderRepo.new
  end
end
