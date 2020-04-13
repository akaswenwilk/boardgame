RSpec.describe "POST /games" do
  subject { post "/games", params.to_json, { "CONTENT_TYPE" => "application/json" } }
  let(:token) { 'some-token' }

  let(:params) do
    {
      token: token
    }
  end

  it_behaves_like "admin only endpoint"
end
