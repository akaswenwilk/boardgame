class GameService
  def create
    game_id = game_repo.create
    tile_repo.populate_game(game_id)

    game_id
  end

  private

  def game_repo
    @game_repo ||= GameRepo.new
  end

  def tile_repo
    @tile_repo ||= TileRepo.new
  end
end
