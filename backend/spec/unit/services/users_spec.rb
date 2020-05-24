RSpec.describe UserService do
  let(:user_repo_class) { UserRepo }
  let(:user_repo_double) { instance_double(user_repo_class) }
  let(:token) { 'some-token' }
  let(:email) { "example@gmail.com" }
  let(:password) { '12345678' }
  let(:user_id) { 1 }
  let(:user_class) { User }
  let(:user) { build(:user) }

  before do
    allow(user_repo_class).to receive(:new).and_return(user_repo_double)
    allow(user_repo_double).to receive(:create).and_return(user)
    allow(user_repo_double).to receive(:generate_token).and_return(token)
    allow(user_class).to receive(:new).and_return(user)
    allow(user).to receive(:validate!).and_return(true)
  end

  describe "#create" do
    subject { described_class.new.create(params) }
    let(:params) do
      user_params.merge({password_confirmation: password_confirmation})
    end

    let(:user_params) do
      {
        email: email,
        password: password,
      }
    end
    let(:password_confirmation) { '12345678' }

    it "instantiates a user and generates a token" do
      expect(User).to receive(:new).with(user_params)
      expect(user_repo_double).to receive(:create).with(user: user, password_confirmation: password_confirmation)
      expect(user_repo_double).to receive(:generate_token).with(user: user)

      subject
      expect(subject).to eq(token)
    end
  end

  describe "#login" do
    subject { described_class.new.login(params) }

    let(:params) do
      {
        email: email,
        password: password
      }
    end

    before do
      allow(user_repo_double).to receive(:authenticate).and_return(user)
    end

    it "instantiates a user, authenticates and returns a token" do
      expect(User).to receive(:new).with(params)
      expect(user_repo_double).to receive(:authenticate).with(user: user)
      expect(user_repo_double).to receive(:generate_token).with(user: user)

      subject
      expect(subject).to eq(token)
    end
  end
end
