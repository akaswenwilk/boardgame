RSpec.describe "POST /games" do
  subject { post "/games", params.to_json, { "CONTENT_TYPE" => "application/json" } }
  let(:token) { 'some-token' }
  let(:admin) { true }
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

  let(:params) do
    {
      token: token
    }
  end

  before do
    DB[:users].insert(**user)
  end

  it_behaves_like "admin only endpoint"

  it "creates a game" do
    expect{ subject }.to change{ DB[:games].count }.by(1)
  end

  it "creates the tiles" do
    expect { subject }.to change{ DB[:tiles].count }.by(101)
  end

  it "creates the center holder" do
    expect { subject }.to change{ DB[:tile_holders].count }.by(1)
  end

  it "adds the first tile to the holder" do
    subject
    expect(JSON(DB[:tile_holders].first[:current_tiles]).length).to eq(1)
  end

  it "returns the game id" do
    subject

    expect(JSON(last_response.body)["id"]).to eq(DB[:games].first[:id])
    expect(last_response.status).to eq(201)
  end
end
