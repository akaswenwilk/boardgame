class TileHolder
  attr_accessor :tiles

  def initialize(params = {})
    params = params&.with_indifferent_access
    @tiles = params&.fetch(:tiles, nil) || []
    @tiles&.map! { |hash| Tile.new(hash) }
  end

  def attributes
    begin
    { tiles: tiles.compact.map(&:attributes) }
    rescue => e
      raise StandardError.new(tiles.inspect)
    end
  end
end
