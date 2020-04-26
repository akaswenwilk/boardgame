class PlayerRepo
  def initialize
    @player = DB[:players]
  end

  def create(name, game_id)
    raise ValidationError.new("max 4 players allowed") if @player.where(game_id: game_id).count >= 4

    @player.insert(name: name, game_id: game_id)
  end
end
