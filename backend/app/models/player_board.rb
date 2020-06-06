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
    @ending_spaces ||= new_ending_spaces
    @ending_spaces = JSON(@ending_spaces) if @ending_spaces.is_a?(String)
    @negative_spaces ||= []
    @negative_spaces = JSON(@negative_spaces) if @negative_spaces.is_a?(String)
  end

  def attributes
    {
      game_id: game_id,
      player_id: player_id,
      id: id,
      playing_spaces: playing_spaces.to_json,
      ending_spaces: ending_spaces.to_json,
      negative_spaces: negative_spaces.to_json,
      points: points
    }.compact
  end

  def valid_move?(n, color)
    row = playing_spaces[n].with_indifferent_access
    return false if row[:tiles].length >= row[:max_length]

    if row[:tiles].length > 0
      return false unless row[:tiles].map(&:with_indifferent_access).map{ |tile| tile[:color] }.first == color
    end

    ending_row = ending_spaces[n].with_indifferent_access
    ending_row[:tiles].each do |tile|
      if !tile["id"].nil?
        return false if tile["color"] == color
      end
    end

    true
  end

  private

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
