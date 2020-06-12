class PlayerService
  def create(args)
    game = game_repo.find(args.delete(:game_id))
    args[:game] = game
    player = player_repo.create(**args)
    player_board_repo.create(player: player, game: game)
    game.players = player_repo.all_by_game(game)
    game.push_outside_tile_holders(game.players.count)
    game_repo.update(game)
    game.players.each { |p| p.player_board = player_board_repo.find_by_player(p.id) }

    game
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
