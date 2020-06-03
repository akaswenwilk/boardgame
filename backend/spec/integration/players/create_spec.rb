RSpec.describe "POST /games/:game_id/players" do
  subject { post "/games/#{game_id}/players", params.to_json, { "CONTENT_TYPE" => "application/json" } }
  let(:token) { 'some-token' }
  let(:admin) { false }
  let(:password) { '12345678' }
  let(:email) { 'some-email@example.com' }
  let(:user) do
    {
      email: email,
      password: password,
      token: token,
      admin: admin
    }
  end
  let(:name) { 'some-name' }
  let(:params) do
    {
      token: token,
      name: name
    }
  end
  let(:game_id) { 1 }

  before do
    DB[:users].insert(**user)
    DB[:games].insert(id: game_id)
  end

  it_behaves_like "authenticated endpoint"

  it "creates a player" do
    expect{subject}.to change{ DB[:players].count }.by(1)
  end

  it "creates a player board" do
    expect{subject}.to change{ DB[:player_boards].count }.by(1)
  end

  context "when there are already 4 players" do
    before do
      DB[:players].insert(name: name, game_id: game_id)
      DB[:players].insert(name: name, game_id: game_id)
      DB[:players].insert(name: name, game_id: game_id)
      DB[:players].insert(name: name, game_id: game_id)
    end

    it "returns an error" do
      expect{subject}.to change{ DB[:players].count }.by(0)
      expect(last_response.status).to eq(400)
    end
  end

  context "when creating players" do
    it "creates outside tile holders" do
      post "/games/#{game_id}/players", params.to_json, { "CONTENT_TYPE" => "application/json" }
      game = Game.new(DB[:games].where(id: game_id).first)
      expect(game.outside_tile_holders.length).to eq(0)

      post "/games/#{game_id}/players", params.to_json, { "CONTENT_TYPE" => "application/json" }
      game = Game.new(DB[:games].where(id: game_id).first)
      expect(game.outside_tile_holders.length).to eq(5)

      post "/games/#{game_id}/players", params.to_json, { "CONTENT_TYPE" => "application/json" }
      game = Game.new(DB[:games].where(id: game_id).first)
      expect(game.outside_tile_holders.length).to eq(7)

      post "/games/#{game_id}/players", params.to_json, { "CONTENT_TYPE" => "application/json" }
      game = Game.new(DB[:games].where(id: game_id).first)
      expect(game.outside_tile_holders.length).to eq(9)
    end
  end
end
