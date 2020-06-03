class PlayerService
  def create(args)
    game = game_repo.find(args.delete(:game_id))
    args[:game] = game
    player = player_repo.create(**args)
    player_board_repo.create(player: player, game: game)
    game_players = player_repo.all_by_game(game)
    game.push_outside_tile_holders(game_players.count)
    game_repo.update(game)

    player
  end

  private

  def game_repo
    @game_repo ||= GameRepo.new
  end

  def player_repo
    @player_repo ||= PlayerRepo.new
  end

  def player_board_repo
    @player_board_repo ||= PlayerBoardRepo.new
  end
end
