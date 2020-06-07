class PlayerRepo
  def initialize
    @player = DB[:players]
  end

  def create(name:, game:, user:)
    raise ValidationError.new("max 4 players allowed") if @player.where(game_id: game.id).count >= 4

    player = Player.new({name: name, game_id: game.id, user_id: user.id})
    id = @player.insert(**player.attributes)
    player.id = id

    player
  end

  def all_by_game(game)
    players = @player.where(game_id: game.id).all
    players.map! { |data| Player.new(data) }
  end

  def delete_all(game_id)
    @player.where(game_id: game_id).delete
  end
end
