class GameService
  def create
    game = game_repo.create
    tile_repo.populate_game(game)
    game_repo.update(game)
    game
  end

  def start(game_id)
    game = game_repo.find(game_id)
    game.started = true
    players = player_repo.all_by_game(game)
    raise ValidationError.new("Must have between 2 and 4 players") unless players.count >= 2 && players.count <= 4
    game.set_player_order(players)
    game.increment_current_player
    game.distribute_tiles_to_outside_holders

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

  def player_repo
    @player_repo ||= PlayerRepo.new
  end
end
