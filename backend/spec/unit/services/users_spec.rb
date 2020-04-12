RSpec.describe UserService do
  describe "#create" do
    subject { described_class.new.create(**user_params) }
    let(:user_params) do
      {
        email: email,
        password: password,
        password_confirmation: password_confirmation
      }
    end
    let(:email) { "example@gmail.com" }
    let(:password) { '12345678' }
    let(:password_confirmation) { '12345678' }
    let(:user_repo_class) { UserRepo }
    let(:user_repo_double) { instance_double(user_repo_class) }
    let(:user_id) { 1 }
    let(:token) { 'some-token' }

    before do
      allow(user_repo_class).to receive(:new).and_return(user_repo_double)
      allow(user_repo_double).to receive(:create).and_return(user_id)
      allow(user_repo_double).to receive(:generate_token).and_return(token)
    end

    it "calls create on the user repo" do
      expect(user_repo_double).to receive(:create).with(**user_params)

      subject
    end

    it "generates a token" do
      expect(user_repo_double).to receive(:generate_token).with(user_id: user_id)

      subject
    end

    it "returns a token" do
      expect(subject).to eq(token)
    end
  end
end
