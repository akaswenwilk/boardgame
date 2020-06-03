class PlayerBoard
  attr_accessor :id, :game_id, :player_id, :playing_spaces, :negative_spaces, :ending_spaces, :points

  def initialize(args = {})
    @game_id = args.fetch(:game_id, nil)
    @player_id = args.fetch(:player_id, nil)
    @id = args.fetch(:id, nil)
    @playing_spaces = args.fetch(:playing_spaces, nil)
    @ending_spaces = args.fetch(:ending_spaces, nil)
    @negative_spaces = args.fetch(:negative_spaces, nil)
    @points = args.fetch(:points, 0)
    @playing_spaces ||= new_playing_spaces
    @ending_spaces ||= new_ending_spaces
    @negative_spaces ||= []
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

  private

  def new_playing_spaces
    {
      row_one: {
        max_length: 1,
        tiles: []
      },
      row_two: {
        max_length: 2,
        tiles: []
      },
      row_three: {
        max_length: 3,
        tiles: []
      },
      row_four: {
        max_length: 4,
        tiles: []
      },
      row_five: {
        max_length: 5,
        tiles: []
      },
    }
  end

  def new_ending_spaces
    {
      row_one: {
        tiles: [
          {id: nil, color: Tile::BLUE},
          {id: nil, color: Tile::YELLOW},
          {id: nil, color: Tile::RED},
          {id: nil, color: Tile::BLACK},
          {id: nil, color: Tile::LIGHT_BLUE}
        ]
      },
      row_two: {
        tiles: [
          {id: nil, color: Tile::LIGHT_BLUE},
          {id: nil, color: Tile::BLUE},
          {id: nil, color: Tile::YELLOW},
          {id: nil, color: Tile::RED},
          {id: nil, color: Tile::BLACK}
        ]
      },
      row_three: {
        tiles: [
          {id: nil, color: Tile::BLACK},
          {id: nil, color: Tile::LIGHT_BLUE},
          {id: nil, color: Tile::BLUE},
          {id: nil, color: Tile::YELLOW},
          {id: nil, color: Tile::RED}
        ]
      },
      row_four: {
        tiles: [
          {id: nil, color: Tile::RED},
          {id: nil, color: Tile::BLACK},
          {id: nil, color: Tile::LIGHT_BLUE},
          {id: nil, color: Tile::BLUE},
          {id: nil, color: Tile::YELLOW}
        ]
      },
      row_five: {
        tiles: [
          {id: nil, color: Tile::YELLOW},
          {id: nil, color: Tile::RED},
          {id: nil, color: Tile::BLACK},
          {id: nil, color: Tile::LIGHT_BLUE},
          {id: nil, color: Tile::BLUE}
        ]
      },
    }
  end
end
