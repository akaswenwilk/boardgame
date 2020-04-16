class TileRepo
  BLUE = "blue"
  RED = "red"
  BLACK = "black"
  LIGHT_BLUE = "light_blue"
  YELLOW = "yellow"
  FIRST = "first"

  COLORS = [
    BLUE,
    RED,
    BLACK,
    LIGHT_BLUE,
    YELLOW
  ]

  def initialize
    @model = DB[:tiles]
  end

  def populate_game(game_id)
    COLORS.each do |color|
      20.times { @model.insert(game_id: game_id, color: color) }
    end

    @model.insert(game_id: game_id, color: FIRST)
  end

  def get_first_tile(game_id)
    @model.where(game_id: game_id, color: FIRST).first
  end
end
