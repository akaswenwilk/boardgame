class PlayerRepo
  def initialize
    @player = DB[:players]
  end

  def create(name, game_id, user)
    raise ValidationError.new("max 4 players allowed") if @player.where(game_id: game_id).count >= 4

    player = Player.new({name: name, game_id: game_id, user_id: user.id})

    @player.insert(**player.attributes)
    player
  end
end
