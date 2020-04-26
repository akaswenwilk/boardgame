class PlayerService
  def create(name, game_id)
    player_repo.create(name, game_id)
  end

  private

  def player_repo
    @player_repo ||= PlayerRepo.new
  end
end
