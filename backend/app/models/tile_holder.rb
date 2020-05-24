class TileHolder
  attr_accessor :tiles

  def initialize(params = {})
    @tiles = params&.fetch(:tiles, nil) || []
  end

  def attributes
    tiles.map(&:attributes)
  end
end
