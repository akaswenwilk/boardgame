class Game
  attr_accessor(
    :id,
    :started,
    :winner_id,
    :current_player_id,
    :tiles_in_bag,
    :center_tile_holder,
    :outside_tile_holders
  )

  def initialize(params = {})
    @id = params.fetch(:id, nil)
    @started = params.fetch(:started, false)
    @winner_id = params.fetch(:winner_id, nil)
    @current_player_id = params.fetch(:current_player_id, nil)
    @tiles_in_bag = params.fetch(:tiles_in_bag, [])
    @tiles_in_bag ||= []
    @center_tile_holder = TileHolder.new(params.fetch(:center_tile_holder, nil))
    @outside_tile_holders = params.fetch(:outside_tile_holders, []) || []
    @outside_tile_holders.map! { |data| TileHolder.new(data) }
  end

  def attributes
    r = {
      id: id,
      started: started,
      winner_id: winner_id,
      current_player_id: current_player_id,
      tiles_in_bag: tiles_in_bag.map(&:attributes).to_json,
      center_tile_holder: center_tile_holder.attributes.to_json,
      outside_tile_holders: outside_tile_holders.map(&:attributes).to_json
    }.compact
  end

  def push_outside_tile_holders(player_count)
    current_tile_holders = self.outside_tile_holders.count
    target_tile_holders = case player_count
                            when 2 then 5
                            when 3 then 7
                            when 4 then 9
                            else 0
                          end
    until self.outside_tile_holders.count >= target_tile_holders
      self.outside_tile_holders.push(
        TileHolder.new
      )
    end
  end
end
