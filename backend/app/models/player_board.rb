class PlayerBoard
  attr_accessor(
    :id,
    :game_id,
    :player_id,
    :playing_spaces,
    :negative_spaces,
    :ending_spaces,
    :points
  )

  def initialize(args = {})
    args = args&.with_indifferent_access
    @game_id = args.fetch(:game_id, nil)
    @player_id = args.fetch(:player_id, nil)
    @id = args.fetch(:id, nil)
    @playing_spaces = args.fetch(:playing_spaces, nil)
    @ending_spaces = args.fetch(:ending_spaces, nil)
    @negative_spaces = args.fetch(:negative_spaces, nil)
    @points = args.fetch(:points, 0) || 0
    @playing_spaces ||= new_playing_spaces
    @playing_spaces = JSON(@playing_spaces) if @playing_spaces.is_a?(String)
    initialize_playing_spaces
    @ending_spaces ||= new_ending_spaces
    @ending_spaces = JSON(@ending_spaces) if @ending_spaces.is_a?(String)
    @negative_spaces ||= []
    @negative_spaces = JSON(@negative_spaces) if @negative_spaces.is_a?(String)
    @negative_spaces.map! { |data| Tile.new(data) }
  end

  def initialize_playing_spaces
    @playing_spaces.map! do |s|
      s = s.with_indifferent_access
      {
        max_length: s["max_length"],
        tiles: s["tiles"].map{ |data| Tile.new(data) }
      }.with_indifferent_access
    end
  end

  def attributes
    {
      game_id: game_id,
      player_id: player_id,
      id: id,
      playing_spaces: playing_spaces_as_json,
      ending_spaces: ending_spaces.to_json,
      negative_spaces: negative_spaces.map(&:attributes).to_json,
      points: points
    }.compact
  end

  def playing_spaces_as_json
    playing_spaces.map do |s|
      s = s.with_indifferent_access
      {
        max_length: s[:max_length],
        tiles: s[:tiles].map(&:attributes)
      }
    end.to_json
  end

  def valid_move?(n, color)
    return true if n == 'negative'
    row = playing_spaces[n].with_indifferent_access
    return false if row[:tiles].length >= row[:max_length]

    if row[:tiles].length > 0
      return false unless row[:tiles].first.color == color
    end

    ending_row = ending_spaces[n].with_indifferent_access
    ending_row[:tiles].each do |tile|
      if !tile["id"].nil?
        return false if tile["color"] == color
      end
    end

    true
  end

  def add_tiles(tiles, n, game)
    unless n == 'negative'
      row = playing_spaces[n].with_indifferent_access

      tiles.each do |tile|
        unless row[:tiles].length >= row[:max_length] || tile.color == Tile::FIRST
          row[:tiles] << tile
        else
          if negative_spaces.length < 7
            negative_spaces << tile
          elsif negative_spaces.length >= 7 && tile.color == Tile::FIRST
            old_tile = negative_spaces.shift
            negative_spaces.unshift(tile)
            game.used_tiles << old_tile
          else
            game.used_tiles << tile
          end
        end
      end

      playing_spaces[n] = row
    else
      tiles.each do |tile|
        if negative_spaces.length < 7
          negative_spaces << tile
        elsif negative_spaces.length >= 7 && tile.color == Tile::FIRST
          old_tile = negative_spaces.shift
          negative_spaces.unshift(tile)
          game.used_tiles << old_tile
        else
          game.used_tiles << tile
        end
      end
    end
  end

  def score_points(game)
    playing_spaces.each_with_index do |space, i|
      space = space.with_indifferent_access
      if space[:tiles].length >= space[:max_length]
        ending_space = ending_spaces[i]["tiles"].find { |s| s["color"] == space[:tiles].first.color }
        ending_space["id"] = space[:tiles].first.id
        space[:tiles] = []
        row = i
        column = ending_spaces[i]["tiles"].index(ending_space)
        add_horizontal_points(row, column)
        add_vertical_points(row, column)
      end
    end

    negative_spaces.length.times do |n|
      self.points -= case n
        when 0, 1 then 1
        when 2, 3, 4 then 2
        else 3
        end

      self.points = 0 if self.points < 0

      tile = negative_spaces.pop

      if tile.color == Tile::FIRST
        game.center_tile_holder.tiles << tile
      else
        game.used_tiles << tile
      end
    end
  end

  def has_full_row?
    result = false
    ending_spaces.each do |space|
      space = space.with_indifferent_access
      result = true if space[:tiles].all? { |t| !t["id"].nil? }
    end

    result
  end

  def score_special_points
    score_horizontal_rows
    score_vertical_rows
    score_all_colors
  end

  private

  def score_horizontal_rows
    ending_spaces.each do |es|
      self.points += 2 if es["tiles"].none? { |t| t["id"].nil? }
    end
  end

  def score_vertical_rows
    5.times do |n|
      has_tiles_in_column = true
      ending_spaces.each do |es|
       has_tiles_in_column = false if es["tiles"][n]["id"].nil?
      end

      self.points += 7 if has_tiles_in_column
    end
  end

  def score_all_colors
    Tile::COLORS.each do |color|
      has_all_of_color = true
      ending_spaces.each do |es|
        tile = es["tiles"].find{ |t| t["color"] == color }
        has_all_of_color = false if tile["id"].nil?
      end

      self.points += 10 if has_all_of_color
    end
  end

  def add_vertical_points(row, column)
    self.points += 1
    i = row - 1
    until i <= 0
      break if ending_spaces[i]["tiles"][column]["id"].nil?

      self.points += 1
      i -= 1
    end

    i = row + 1
    until i >= 4
      break if ending_spaces[i]["tiles"][column]["id"].nil?

      self.points += 1
      i += 1
    end
  end

  def add_horizontal_points(row, column)
    self.points += 1
    i = column - 1
    until i <= 0
      break if ending_spaces[row]["tiles"][i]["id"].nil?

      self.points += 1
      i -= 1
    end

    i = column + 1
    until i >= 4
      break if ending_spaces[row]["tiles"][i]["id"].nil?

      self.points += 1
      i += 1
    end
  end

  def new_playing_spaces
    [
      {
        max_length: 1,
        tiles: []
      },
      {
        max_length: 2,
        tiles: []
      },
      {
        max_length: 3,
        tiles: []
      },
      {
        max_length: 4,
        tiles: []
      },
      {
        max_length: 5,
        tiles: []
      },
    ]
  end

  def new_ending_spaces
    [
      {
        tiles: [
          {id: nil, color: Tile::BLUE},
          {id: nil, color: Tile::YELLOW},
          {id: nil, color: Tile::RED},
          {id: nil, color: Tile::BLACK},
          {id: nil, color: Tile::LIGHT_BLUE}
        ]
      },
      {
        tiles: [
          {id: nil, color: Tile::LIGHT_BLUE},
          {id: nil, color: Tile::BLUE},
          {id: nil, color: Tile::YELLOW},
          {id: nil, color: Tile::RED},
          {id: nil, color: Tile::BLACK}
        ]
      },
      {
        tiles: [
          {id: nil, color: Tile::BLACK},
          {id: nil, color: Tile::LIGHT_BLUE},
          {id: nil, color: Tile::BLUE},
          {id: nil, color: Tile::YELLOW},
          {id: nil, color: Tile::RED}
        ]
      },
      {
        tiles: [
          {id: nil, color: Tile::RED},
          {id: nil, color: Tile::BLACK},
          {id: nil, color: Tile::LIGHT_BLUE},
          {id: nil, color: Tile::BLUE},
          {id: nil, color: Tile::YELLOW}
        ]
      },
      {
        tiles: [
          {id: nil, color: Tile::YELLOW},
          {id: nil, color: Tile::RED},
          {id: nil, color: Tile::BLACK},
          {id: nil, color: Tile::LIGHT_BLUE},
          {id: nil, color: Tile::BLUE}
        ]
      },
    ]
  end
end
