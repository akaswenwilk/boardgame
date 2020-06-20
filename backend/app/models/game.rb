class Game
  attr_accessor(
    :id,
    :started,
    :winner_name,
    :current_player_id,
    :tiles_in_bag,
    :center_tile_holder,
    :outside_tile_holders,
    :player_order,
    :used_tiles,
    :players
  )

  def initialize(params = {})
    params = params.with_indifferent_access
    @id = params.fetch(:id, nil)
    @started = params.fetch(:started, false)
    @winner_name = params.fetch(:winner_name, nil)
    @current_player_id = params.fetch(:current_player_id, nil)
    @tiles_in_bag = params.fetch(:tiles_in_bag, []) || []
    @tiles_in_bag.map! { |hash| Tile.new(hash) }
    @center_tile_holder = TileHolder.new(params.fetch(:center_tile_holder, nil))
    @outside_tile_holders = params.fetch(:outside_tile_holders, []) || []
    @outside_tile_holders.map! { |data| TileHolder.new(data) }
    @player_order = params.fetch(:player_order, [])
    @used_tiles = params.fetch(:used_tiles, []) || []
    @used_tiles.map! { |hash| Tile.new(hash) }
  end

  def attributes
    r = {
      id: id,
      started: started,
      winner_name: winner_name,
      current_player_id: current_player_id,
      tiles_in_bag: tiles_in_bag.map(&:attributes).to_json,
      center_tile_holder: center_tile_holder.attributes.to_json,
      outside_tile_holders: outside_tile_holders.map(&:attributes).to_json,
      player_order: player_order.to_json,
      used_tiles: used_tiles.map(&:attributes).to_json
    }.compact
  end

  def full_attributes
    r = attributes
    r.merge!({
      players: players.map(&:attributes_with_board)
    })

    r
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

  def set_player_order(players)
    self.player_order = players.map(&:id).shuffle
  end

  def increment_current_player
    return self.current_player_id = player_order.first if current_player_id.nil? || current_player_id == player_order.last

    current_index = player_order.index(current_player_id)
    self.current_player_id = player_order[current_index + 1]
  end

  def distribute_tiles_to_outside_holders
    outside_tile_holders.each do |holder|
      4.times do
        if tiles_in_bag.count == 0
          self.tiles_in_bag = used_tiles
          tiles_in_bag.shuffle!
          self.used_tiles = []
        end

        holder.tiles << tiles_in_bag.pop
      end
    end
  end

  def tiles_from_holder(tile_holder, color)
    if tile_holder == 'center'
      selected_holder = center_tile_holder
    else
      selected_holder = outside_tile_holders[tile_holder]
    end

    result = selected_holder.tiles.select { |t| t.color == color }
    selected_holder.tiles.reject! { |t| t.color == color }

    if tile_holder == 'center'
      result.push(selected_holder.tiles.find { |t| t.color == Tile::FIRST })
      selected_holder.tiles.reject! { |t| t.color == Tile::FIRST }
    else
      center_tile_holder.tiles.push(selected_holder.tiles).flatten!
      selected_holder.tiles = []
    end

    result.compact
  end

  def end_of_round?
    center_tile_holder.tiles.empty? && outside_tile_holders.all? { |th| th.tiles.empty? }
  end
end
