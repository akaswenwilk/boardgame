class PlayerService
  def create(args)
    player_repo.create(*args)
  end

  private

  def player_repo
    @player_repo ||= PlayerRepo.new
  end
end
