RSpec.describe "POST /games" do
  subject { post "/games/#{game_id}/players/#{player_id}/move", params.to_json, { "CONTENT_TYPE" => "application/json" } }

  let(:user) { create(:user, token: token, admin: admin) }
  let(:token) { 'some-token' }
  let(:admin) { false }
  let(:game) { create(:game, user: user, players: player_number, populated: true, started: true) }
  let(:player_number) { 2 }
  let(:game_id) { game.id }
  let(:player_id) { game.current_player_id }
  let(:player) { game.players.select { |p| p.id == player_id }.first }
  let!(:player_board) { create(:player_board, player_id: player.id, game_id: game.id) }
  let!(:player_board2) { create(:player_board, player_id: game.player_order.last, game_id: game.id) }

  let(:params) do
    {
      token: token,
      tile_holder: tile_holder,
      color: color,
      row: row
    }
  end

  let(:tile_holder) { 0 }
  let(:color) { Tile::BLUE }
  let(:colors_on_tile) { color }
  let(:row) { 0 }
  let(:res_body) { JSON(last_response.body) }
  let(:res_body_player) { res_body["players"].find{ |p| p["id"] == player_id } }
  let(:res_body_player_board) { res_body_player["player_board"] }
  let(:res_body_playing_spaces) { JSON(res_body_player_board["playing_spaces"]) }
  let(:res_body_ending_spaces) { JSON(res_body_player_board["ending_spaces"]) }
  let(:res_body_negative_spaces) { JSON(res_body_player_board["negative_spaces"]) }
  let(:res_body_center_tile_holder) { JSON(res_body["center_tile_holder"]) }
  let(:res_body_outside_tile_holders) { JSON(res_body["outside_tile_holders"]) }
  let(:res_body_used_tiles) { JSON(res_body["used_tiles"]) }
  let(:res_body_tiles_in_bag) { JSON(res_body["tiles_in_bag"]) }

  before do
    game
    tiles = DB[:tiles].where(color: colors_on_tile).first(2).map{ |data| Tile.new(data) }
    tiles << DB[:tiles].where(color: Tile::LIGHT_BLUE).first(2).map{ |data| Tile.new(data) }
    game.outside_tile_holders.first.tiles = tiles.flatten
    DB[:games].where(id: game.id).update(**game.attributes)
  end

  it_behaves_like "authenticated endpoint"

  context "when a valid move" do
    context "when not last move of round" do
      it "returns the full game" do
        subject

        expect(last_response.status).to eq 200
        expect(res_body.keys).to eq([
          "id",
          "started",
          "current_player_id",
          "tiles_in_bag",
          "center_tile_holder",
          "outside_tile_holders",
          "player_order",
          "used_tiles",
          "players"
        ])
      end

      it "takes all of the same color and puts it into the row and other into center" do
        subject

        expect(res_body["winner_name"]).to be_nil
        expect(res_body_playing_spaces[0]["tiles"].length).to eq 1
        tile = Tile.new(res_body_playing_spaces[0]["tiles"].first)
        expect(tile.id).not_to be nil
        expect(tile.color).to eq color
        expect(res_body_outside_tile_holders[0]["tiles"].length).to eq 0
        expect(res_body_center_tile_holder["tiles"].length).to eq 3
      end

      it "changes current player id to next in player order" do
        subject

        expect(res_body["current_player_id"]).to eq game.player_order[1]
      end

      it "puts overflowed tiles to negative spaces" do
        subject

        expect(res_body_negative_spaces.length).to eq 1
      end

      context "when there are extra tiles even after negative spaces" do
        before do
          tiles = DB[:tiles].first(7)
          tiles.map! { |data| Tile.new(data) }
          player_board.negative_spaces = tiles
          DB[:player_boards].where(id: player_board.id).update(**player_board.attributes)
        end

        it "puts the extras into used tiles" do
          subject

          expect(res_body_used_tiles.length).to eq 1
          expect(res_body_used_tiles.first["id"]).not_to be nil
        end
      end

      context "when taking from the center" do
        let(:tile_holder) { 'center' }

        before do
          tiles = DB[:tiles].where(color: colors_on_tile).first(5).map { |data| Tile.new(data) }
          game.center_tile_holder.tiles << tiles
          tiles = DB[:tiles].where(color: Tile::LIGHT_BLUE).first(5).map { |data| Tile.new(data) }
          game.center_tile_holder.tiles << tiles
          game.center_tile_holder.tiles.flatten!
          DB[:games].where(id: game.id).update(**game.attributes)
        end

        it "takes all of the same color and puts it into the row" do
          subject

          expect(res_body_center_tile_holder["tiles"].length).to eq 5
          expect(res_body_playing_spaces.first["tiles"].length).to eq 1
        end

        it "takes the first player token and puts it into negative spaces" do
          subject

          expect(res_body_negative_spaces.length).to eq 5
          expect(res_body_negative_spaces.find{|t| t["color"] == Tile::FIRST}).not_to be_nil
        end

        context "when negative spaces are full" do
          before do
            tiles = DB[:tiles].where(color: Tile::RED).first(7).map{ |data| Tile.new(data) }
            player_board.negative_spaces = tiles
            DB[:player_boards].where(id: player_board.id).update(**player_board.attributes)
          end

          it "replaces first negative space with first tile" do
            subject

            expect(res_body_negative_spaces.length).to eq 7
            expect(res_body_negative_spaces.find{|t| t["color"] == Tile::FIRST}).not_to be_nil
          end
        end
      end
    end

    context "when last move of the round" do
      let(:tile_holder) { 'center' }
      let(:tile_number) { 5 }

      before do
        game.outside_tile_holders.each do |th|
          game.used_tiles << th.tiles
          game.used_tiles.flatten!
          th.tiles = []
        end

        tiles = DB[:tiles].where(color: colors_on_tile).first(tile_number).map { |data| Tile.new(data) }
        game.center_tile_holder.tiles << tiles
        game.center_tile_holder.tiles.flatten!

        DB[:games].where(id: game.id).update(**game.attributes)
      end

      context "when not the end of the game" do
        it "sets current player id to whomever had the first player token" do
          subject

          expect(res_body["winner_name"]).to be_nil
          expect(res_body["current_player_id"]).to eq player_id
        end

        context "when there are points to be scored" do
          let(:tile_number) { 1 }
          before do
            first_row = player_board.ending_spaces.first
            first_row[:tiles].map!.with_index do |r, i|
              {
                id: r[:color] == color || i == 3? nil : i,
                color: r[:color]
              }
            end

            (1..4).each do |n|
              unless n == 2
                row = player_board.ending_spaces[n]
                row[:tiles][0] = {
                  id: 1,
                  color: row[:tiles][0][:color]
                }
              end
            end
            DB[:player_boards].where(id: player_board.id).update(**player_board.attributes)
          end

          it "scores points" do
            subject

            expect(last_response.status).to eq 200
            expect(res_body_player_board["points"]).to eq 4
            expect(res_body_playing_spaces[0]["tiles"].length).to eq 0
            expect(res_body_ending_spaces[0]["tiles"].find{ |t| t["color"] == color}["id"]).not_to be nil
          end
        end

        it "redistributes tiles" do
          subject

          res_body_outside_tile_holders.each do |th|
            expect(th["tiles"].length).to eq 4
          end

          expect(res_body_center_tile_holder["tiles"].length).to eq 1
        end

        context "when playing spaces is not full" do
          before do
            tiles = DB[:tiles].first(3)
            tiles.map! { |data| Tile.new(data) }
            player_board.playing_spaces[4]["tiles"] = tiles
            DB[:player_boards].where(id: player_board.id).update(**player_board.attributes)
          end
          it "leaves the tiles where they are" do
            subject

            expect(res_body_playing_spaces[4]["tiles"].length).to eq 3
          end
        end

        context "when tiles in bag are empty" do
          before do
            game.used_tiles.push(game.tiles_in_bag).flatten!
            game.tiles_in_bag = []
            DB[:games].where(id: game.id).update(**game.attributes)
          end

          it "empties used tiles and refills bag" do
            subject

            expect(res_body_used_tiles).to be_empty
            expect(res_body_tiles_in_bag).not_to be_empty
          end
        end
      end

      context "when the end of the game" do
        before do
          player_board.ending_spaces[0][:tiles].map! do |tile|
            {
              id: tile[:color] == color ? nil : 1,
              color: tile[:color]
            }
          end
          DB[:player_boards].where(id: player_board.id).update(**player_board.attributes)
        end

        it "returns a winner id" do
          subject

          expect(res_body["winner_name"]).not_to be_nil
        end

        it "returns started as false" do
          subject

          expect(res_body["started"]).to eq false
        end

        context "when there are special points" do
          context "when there is a full row" do
            it "counts an extra two points" do
              subject

              expect(res_body_player_board["points"]).to eq 2
            end
          end
          context "when there is a full column" do
            before do
              player_board.ending_spaces.each_with_index do |es, i|
                next if i == 0

                es[:tiles][0][:id] = 1
              end
              DB[:player_boards].where(id: player_board.id).update(**player_board.attributes)
            end

            it "adds an extra 7 points" do
              subject

              expect(res_body_player_board["points"]).to eq 9
            end
          end

          context "when there are five of a color" do
            before do
              player_board.ending_spaces.each_with_index do |es, i|
                next if i == 0

                es[:tiles].map! do |tile|
                  {
                    id: tile[:color] == color ? 1 : nil,
                    color: tile[:color]
                  }
                end
              end
              DB[:player_boards].where(id: player_board.id).update(**player_board.attributes)
            end

            it "adds an extra 10 points" do
              subject

              expect(res_body_player_board["points"]).to eq 12
            end
          end
        end
      end
    end
  end

  context "when not a valid move" do
    context "when row is invalid row for selection" do
      before do
        single_tile = Tile.new(DB[:tiles].all.last)
        player_board.playing_spaces[0]["tiles"] = [single_tile]
        DB[:player_boards].where(id: player_board.id).update(**player_board.attributes)
      end

      it "returns an error" do
        subject

        expect(last_response.status).to eq(400)
      end
    end
  end
end
