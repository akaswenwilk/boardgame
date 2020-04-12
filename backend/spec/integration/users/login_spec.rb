RSpec.describe "POST /users/login" do
  subject { post "/users/login", params, { "CONTENT_TYPE" => "application/json" } }
  let(:params) do
    {
      email: email,
      password: password,
    }.to_json
  end
  let(:email) { 'some-email@example.com' }
  let(:password) { 'some-password1' }

  let(:old_token) { 'some-old-token' }
  let(:new_token) { 'some-new-token' }
  let(:response) do
    {
      "token" => new_token
    }
  end

  before do
    allow(SecureRandom).to receive(:base64).and_return(new_token)
    DB[:users].insert(email: email, password: Digest::SHA256.hexdigest(password), token: old_token)
  end

  it "changes user token" do
    expect{ subject }.to change{DB[:users].first[:token]}.from(old_token).to(new_token)
  end

  it "returns the token as json" do
    subject

    expect(JSON(last_response.body)).to eq(response)
    expect(last_response.status).to eq(201)
  end
end

