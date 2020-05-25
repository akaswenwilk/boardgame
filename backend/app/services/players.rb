class PlayerService
  def create(args)
    game = game_repo.find(args.delete(:game_id))
    args[:game] = game
    player_repo.create(**args)
    game_players = player_repo.all_by_game(game)
  end

  private

  def game_repo
    @game_repo ||= GameRepo.new
  end

  def player_repo
    @player_repo ||= PlayerRepo.new
  end
end
