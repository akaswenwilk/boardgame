RSpec.describe PlayerBoardRepo do
  describe "#create" do
    subject { described_class.new.create(**args) }

    let(:args) do
      {
        player: player,
        game: game
      }
    end
    let(:player) { build(:player) }
    let(:game) { build(:game) }
    let(:starting_playing_spaces) do
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

    let(:starting_ending_spaces) do
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

    before do
      game.id = DB[:games].insert
      player.id = DB[:players].insert(**player.attributes)
    end

    it "creates a player board" do
      expect { subject }.to change { DB[:player_boards].count }.by(1)
    end

    it "attaches to the player" do
      subject

      expect(player.player_board.attributes).to eq(DB[:player_boards].where(id: player.player_board.id).first)
    end

    it "has appropriate starting values" do
      subject

      expect(player.player_board.id).not_to be_nil
      expect(player.player_board.player_id).to eq(player.id)
      expect(player.player_board.game_id).to eq(game.id)
      expect(player.player_board.playing_spaces).to eq(starting_playing_spaces)
      expect(player.player_board.ending_spaces).to eq(starting_ending_spaces)
      expect(player.player_board.negative_spaces).to eq([])
      expect(player.player_board.points).to eq(0)
    end
  end
end
