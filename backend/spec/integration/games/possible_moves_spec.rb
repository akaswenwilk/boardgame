RSpec.describe "POST /games" do
  subject { get "/games/#{game_id}/players/#{player_id}/moves#{params_string}", { "CONTENT_TYPE" => "application/json" } }

  let(:params_string) { "?tile_holder=#{tile_holder}&color=#{color}" }
  let(:user) { create(:user) }
  let(:game) { create(:game, user: user, players: player_number, populated: true, started: started) }
  let(:player_number) { 2 }
  let(:game_id) { game.id }
  let(:player_id) { game.current_player_id }
  let(:tile_holder) { 0 }
  let(:color) { Tile::BLUE }
  let(:started) { true }
  let(:colors_on_tile) { color }

  before do
    game
    tiles = DB[:tiles].where(color: colors_on_tile).first(4).map{ |data| Tile.new(data) }
    game.outside_tile_holders.first.tiles = tiles
    DB[:games].where(id: game.id).update(**game.attributes)
  end

  context "when there are no validation errors" do
    let(:player) { game.players.select { |p| p.id == player_id }.first }
    let!(:player_board) { create(:player_board, player_id: player.id, game_id: game.id) }
    let(:response_body) { { possible_rows: possible_rows } }

    context "when player board is empty" do
      let(:possible_rows) { [0, 1, 2, 3, 4] }

      it "returns all rows" do
        subject

        expect(last_response.status).to eq 200
        expect(last_response.body).to eq (response_body.to_json)
      end
    end

    context "when center tile is chosen" do
      let(:tile_holder) { 'center' }
      let(:possible_rows) { [0, 1, 2, 3, 4] }

      before do
        tiles = DB[:tiles].where(color: color).first(4)
        tiles.map!{ |data| Tile.new(data) }
        game.center_tile_holder.tiles.push(tiles).flatten!
        DB[:games].where(id: game.id).update(**game.attributes)
      end

      it "returns all rows" do
        subject

        expect(last_response.status).to eq 200
        expect(last_response.body).to eq (response_body.to_json)
      end
    end

    context "when a row is full" do
      let(:possible_rows) { [1, 2, 3] }

      before do
        single_tile = Tile.new(DB[:tiles].all.last)
        player_board.playing_spaces[0]["tiles"] = single_tile
        five_tiles = DB[:tiles].first(5)
        player_board.playing_spaces[4]["tiles"] = five_tiles
        DB[:player_boards].where(id: player_board.id).update(**player_board.attributes)
      end

      it "doesn't return the full rows" do
        subject

        expect(last_response.status).to eq 200
        expect(last_response.body).to eq (response_body.to_json)
      end
    end

    context "when the row is not full and has the same color" do
      let(:possible_rows) { [0, 1, 2, 3, 4] }

      before do
        four_tiles = DB[:tiles].where(color: color).first(4)
        player_board.playing_spaces[4]["tiles"] = four_tiles
        DB[:player_boards].where(id: player_board.id).update(**player_board.attributes)
      end

      it "returns all rows" do
        subject

        expect(last_response.status).to eq 200
        expect(last_response.body).to eq (response_body.to_json)
      end
    end

    context "when the row is not full but has different color" do
      let(:possible_rows) { [0, 1, 2, 3] }

      before do
        four_tiles = DB[:tiles].where(color: Tile::RED).first(4)
        player_board.playing_spaces[4]["tiles"] = four_tiles
        DB[:player_boards].where(id: player_board.id).update(**player_board.attributes)
      end

      it "doesn't return all rows" do
        subject

        expect(last_response.status).to eq 200
        expect(last_response.body).to eq (response_body.to_json)
      end
    end

    context "when corresponding ending spaces row has tiles, but not the same color" do
      let(:possible_rows) { [0, 1, 2, 3, 4] }

      before do
        id = DB[:tiles].where(color: Tile::RED).first[:id]
        tile = player_board.ending_spaces[4][:tiles].find { |t| t[:color] == Tile::RED }[:id] = id
        DB[:player_boards].where(id: player_board.id).update(**player_board.attributes)
      end

      it "returns all rows" do
        subject

        expect(last_response.status).to eq 200
        expect(last_response.body).to eq (response_body.to_json)
      end
    end

    context "when corresponding ending spaces row has tiles, and one is the same color" do
      let(:possible_rows) { [0, 1, 2, 3] }

      before do
        id = DB[:tiles].where(color: color).first[:id]
        tile = player_board.ending_spaces[4][:tiles].find { |t| t[:color] == color }[:id] = id
        DB[:player_boards].where(id: player_board.id).update(**player_board.attributes)
      end

      it "doesn't returns all rows" do
        subject

        expect(last_response.status).to eq 200
        expect(last_response.body).to eq (response_body.to_json)
      end
    end

    context "when all of the rows are full" do
      let(:possible_rows) { [] }

      before do
        5.times do |n|
          tiles = DB[:tiles].first(n + 1)
          player_board.playing_spaces[n]["tiles"] = tiles
        end

        DB[:player_boards].where(id: player_board.id).update(**player_board.attributes)
      end

      it "doesn't returns all rows" do
        subject

        expect(last_response.status).to eq 200
        expect(last_response.body).to eq (response_body.to_json)
      end
    end
  end

  context "when there are validation errors" do
    context "when the game is not yet started" do
      let(:started) { false }
      let(:player_id) { game.players.first.id }

      it "returns an error" do
        subject

        expect(last_response.status).to eq 400
      end
    end

    context "when the params are missing" do
      let(:params_string) { "" }

      it "returns an error" do
        subject

        expect(last_response.status).to eq 400
      end
    end

    context "when an incorrect number is chosen for tile holders" do
      let(:tile_holder) { 5 }

      it "returns an error" do
        subject

        expect(last_response.status).to eq 400
      end
    end

    context "when an improper color is chosen" do
      let(:color) { 'banana' }

      it "returns an error" do
        subject

        expect(last_response.status).to eq 400
      end
    end

    context "when color is chosen that is not on a tile" do
      let(:colors_on_tile) { Tile::RED }

      it "returns an error" do
        subject

        expect(last_response.status).to eq 400
      end
    end

    context "when tile holder is empty" do
      before do
        game.outside_tile_holders.first.tiles = []
        DB[:games].where(id: game.id).update(**game.attributes)
      end

      it "returns an error" do
        subject

        expect(last_response.status).to eq 400
      end
    end

    context "when it's not the current player's turn" do
      let(:player_id) { game.player_order.last }

      it "returns an error" do
        subject

        expect(last_response.status).to eq 400
      end
    end
  end
end
