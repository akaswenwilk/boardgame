class TileHolder
  attr_accessor :tiles

  def initialize(params = {})
    params = params&.with_indifferent_access
    @tiles = params&.fetch(:tiles, nil) || []
    @tiles&.map! { |hash| Tile.new(hash) }
  end

  def attributes
    { tiles: tiles.map(&:attributes) }
  end
end
