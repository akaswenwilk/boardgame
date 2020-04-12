RSpec.describe UserService do
  let(:user_repo_class) { UserRepo }
  let(:user_repo_double) { instance_double(user_repo_class) }
  let(:token) { 'some-token' }
  let(:email) { "example@gmail.com" }
  let(:password) { '12345678' }
  let(:user_id) { 1 }

  before do
    allow(user_repo_class).to receive(:new).and_return(user_repo_double)
    allow(user_repo_double).to receive(:create).and_return(user_id)
    allow(user_repo_double).to receive(:generate_token).and_return(token)
  end

  describe "#create" do
    subject { described_class.new.create(**user_params) }
    let(:user_params) do
      {
        email: email,
        password: password,
        password_confirmation: password_confirmation
      }
    end
    let(:password_confirmation) { '12345678' }

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

  describe "#login" do
    subject { described_class.new.login(email: email, password: password) }

    before do
      allow(user_repo_double).to receive(:authenticate).and_return(user_id)
    end

    it "authenticates the user" do
      expect(user_repo_double).to receive(:authenticate).with(email: email, password: password)

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
