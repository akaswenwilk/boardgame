RSpec.describe "POST /users" do
  subject { post "/users", params, { "CONTENT_TYPE" => "application/json" } }
  let(:params) do
    {
      email: email,
      password: password,
      password_confirmation: password_confirmation
    }.to_json
  end
  let(:email) { 'some-email@example.com' }
  let(:password) { 'some-password1' }
  let(:password_confirmation) { 'some-password1' }

  let(:token) { 'some-token' }
  let(:response) do
    {
      "token" => token
    }
  end

  before do
    allow(SecureRandom).to receive(:base64).and_return(token)
  end

  it "creates a user" do
    expect{ subject }.to change{DB[:users].count}.by(1)
  end

  it "returns the token as json" do
    subject

    expect(JSON(last_response.body)).to eq(response)
    expect(last_response.status).to eq(201)
  end

  context "when an error is triggered" do
    let(:email) { "wrongemail" }
    let(:response) do
      {
        "error_type" => "ValidationError",
        "error_message" => "email is invalid",
        "request_params" => {
          "email" => email,
          "password" => password,
          "password_confirmation" => password_confirmation
        }
      }
    end

    it "returns an error response" do
      subject

      expect(JSON(last_response.body)).to eq(response)
      expect(last_response.status).to eq(400)
    end
  end
end

