RSpec.describe UserRepo do
  let!(:users) { DB[:users] }
  let(:password) { '12345678' }
  let(:password_confirmation) { password }
  let(:encrypted_password) { Digest::SHA256.hexdigest(password) }
  let(:email) { 'someemail@example.com' }
  let(:id) { 1 }
  let(:token) { 'token' }
  let(:user) { build(:user, password: password, email: email) }

  describe "#create" do
    subject { described_class.new.create(**user_params) }

    let(:user_params) do
      {
        user: user,
        password_confirmation: password_confirmation
      }
    end

    it "saves a new user" do
      user.id = nil
      expect{subject}.to change{ users.count }.by(1)
    end

    it "password is encrypted" do
      expect(users.count).to eq(0)
      subject

      expect(users.first[:password]).not_to eq(password)
      expect(Digest::SHA256.hexdigest(password)).to eq(users.first[:password])
    end

    context "when the password confirmation is different than password" do

      let(:password_confirmation) { '1234' }

      it "raises an error" do
        expect{subject}.to raise_error(ValidationError)
      end
    end

    context "when email is already taken" do
      before do
        users.insert(email: email, password: password)
      end

      it "raises an error" do
        expect{subject}.to raise_error(ValidationError)
      end
    end
  end

  describe "#generate_token" do
    subject { described_class.new.generate_token(user: user) }
    let(:token) { 'some-token' }
    let(:user) { create(:user, token: nil) }

    before do
      allow(SecureRandom).to receive(:base64).and_return(token)
    end

    it "generates a token for the user" do
      expect(user.token).to be_nil
      subject
      expect(users.first[:token]).to eq(token)
    end

    it "returns the token" do
      expect(subject).to eq(token)
    end

    context "when user doesn't exist" do
      before do
        user.id = 2
      end

      it "raises an error when a user isn't found" do
        expect{subject}.to raise_error(ModelNotFoundError)
      end
    end
  end

  describe "#authenticate" do
    subject { described_class.new.authenticate(user: user) }

    before do
      users.insert(email: email, password: encrypted_password, id: id)
    end

    it "returns the user with id" do
      expect(subject.id).to eq(id)
    end

    context "when there's incorrect information" do
      subject { described_class.new.authenticate(user: User.new(email: 'some-wrong-email@example.com', password: password)) }

      it "raises model not found error" do
        expect{subject}.to raise_error ModelNotFoundError
      end
    end
  end

  describe "#find_by_token" do
    subject { described_class.new.find_by_token(token) }

    before do
      users.insert(email: email, password: encrypted_password, id: id, token: token)
    end

    it "returns user" do
      expect(subject.attributes).to eq(User.new(users.first).attributes)
    end

    context "when token is bad" do
      subject { described_class.new.find_by_token('bad-token') }

      it "raises model not found error" do
        expect{subject}.to raise_error(ModelNotFoundError)
      end
    end
  end
end
