class GameRepo
  def initialize
    @model = DB[:games]
  end

  def find(game_id)
    data = @model.first(id: game_id)
    game = Game.new(data)

    game
  end

  def create
    id = @model.insert
    game = Game.new(@model.where(id: id).first)
  end

  def update(game)
    raise ModelNotFoundError.new("game not yet saved, cannot be updated") unless game.id

    @model.where(id: game.id).update(**game.attributes)
  end
end
