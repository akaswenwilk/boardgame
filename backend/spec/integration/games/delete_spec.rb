RSpec.describe "POST /games" do
  subject { delete "/games/#{game_id}", params.to_json, { "CONTENT_TYPE" => "application/json" } }

  let(:user) { create(:user, token: token, admin: admin) }
  let(:game) { create(:game, user: user, players: player_number, populated: true, started: started) }
  let(:player_number) { 2 }
  let(:game_id) { game.id }
  let(:started) { true }
  let(:colors_on_tile) { color }
  let(:admin) { true }
  let(:token) { 'some-token' }
  let(:params) { { token: token } }

  it_behaves_like "admin only endpoint"

  it "deletes everything except user" do
    subject

    expect(last_response.status).to eq(200)
    expect(DB[:games].count).to eq(0)
    expect(DB[:players].count).to eq(0)
    expect(DB[:player_boards].count).to eq(0)
    expect(DB[:tiles].count).to eq(0)
  end
end
