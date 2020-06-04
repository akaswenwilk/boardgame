class Tile
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

  attr_accessor :id, :color, :game_id

  def initialize(args = {})
    args = args&.with_indifferent_access
    @id = args.fetch(:id, nil)
    @game_id = args.fetch(:game_id, nil)
    @color = args.fetch(:color, nil)
  end

  def attributes
    {
      id: id,
      game_id: game_id,
      color: color
    }.compact
  end
end
