RSpec.describe "POST /games" do
  subject { post "/games/#{game_id}/start", params.to_json, { "CONTENT_TYPE" => "application/json" } }
  let(:token) { 'some-token' }
  let!(:user) { create(:user, token: token, admin: admin) }
  let(:admin) { true }
  let(:user_id) { user.id }
  let(:params) { { token: token } }
  let(:game) { create(:game, user: user, players: player_number, populated: true) }
  let(:player_number) { 2 }
  let(:game_id) { game.id }

  it_behaves_like "admin only endpoint"

  it "changes game state from false to true" do
    expect(game.started).to eq false
    subject

    expect(last_response.status).to eq 200
    res = JSON(last_response.body).with_indifferent_access
    expect(res[:id]).to eq game.id
    expect(res[:started]).to eq true
    expect(res[:winner_name]).to eq nil
    expect(res[:current_player_id]).not_to be nil

    player_order = JSON(res[:player_order])
    expect(player_order.length).to eq(player_number)
    expect(player_order.first).to eq(res[:current_player_id])

    tiles_in_bag = JSON(res[:tiles_in_bag])
    expect(tiles_in_bag.length).to eq(80)

    center_tile_holder = JSON(res[:center_tile_holder]).with_indifferent_access
    expect(center_tile_holder[:tiles].length).to eq(1)
    expect(center_tile_holder[:tiles].first[:color]).to eq(Tile::FIRST)

    outside_tile_holders = JSON(res[:outside_tile_holders])
    expect(outside_tile_holders.length).to eq(5)
    outside_tile_holders.each do |th|
      expect(th["tiles"].length).to eq(4)
    end
  end

  context "when it is already started" do
  let(:game) { create(:game, user: user, players: player_number, started: true, populated: true) }

    it "changes nothing" do
      subject

      expect(last_response.status).to eq 200
      res = JSON(last_response.body).with_indifferent_access
      expect(res[:id]).to eq game.id
      expect(res[:started]).to eq true
      expect(res[:winner_name]).to eq nil
      expect(res[:current_player_id]).not_to be nil

      player_order = JSON(res[:player_order])
      expect(player_order.length).to eq(player_number)
      expect(player_order.first).to eq(res[:current_player_id])

      tiles_in_bag = JSON(res[:tiles_in_bag])
      expect(tiles_in_bag.length).to eq(80)

      center_tile_holder = JSON(res[:center_tile_holder]).with_indifferent_access
      expect(center_tile_holder[:tiles].length).to eq(1)
      expect(center_tile_holder[:tiles].first[:color]).to eq(Tile::FIRST)

      outside_tile_holders = JSON(res[:outside_tile_holders])
      expect(outside_tile_holders.length).to eq(5)
      outside_tile_holders.each do |th|
        expect(th["tiles"].length).to eq(4)
      end
    end
  end

  context "when there are too few players" do
    let(:player_number) { 1 }

    it "returns a validation error" do
      subject

      expect(last_response.status).to eq 400
    end
  end

  context "when there are too many players" do
    let(:player_number) { 5 }

    it "returns a validation error" do
      subject

      expect(last_response.status).to eq 400
    end
  end
end
