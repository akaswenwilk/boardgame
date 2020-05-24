class GameService
  def create
    game = game_repo.create
    tile_repo.populate_game(game)
    game_repo.update(game)
    game
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
