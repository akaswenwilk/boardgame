RSpec.describe UserRepo do
  let!(:users) { DB[:users] }
  let(:password) { '12345678' }
  let(:password_confirmation) { password }
  let(:encrypted_password) { Digest::SHA256.hexdigest(password) }
  let(:email) { 'someemail@example.com' }

  describe "#create" do
    subject { described_class.new.create(**user_params) }

    let(:user_params) do
      {
        email: email,
        password: password,
        password_confirmation: password_confirmation
      }
    end

    it "saves a new user" do
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

    context "when there's an invalid email" do
      let(:email) { "examplegmail.com" }

      it "raises an error" do
        expect{subject}.to raise_error(ValidationError)
      end
    end

    context "when password is not long enough" do
      let(:password) { "1234" }

      it "raises an error" do
        expect{subject}.to raise_error(ValidationError)
      end
    end

    context "when password doesn't have at least one number" do
      let(:password) { "password" }

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
    subject { described_class.new.generate_token(user_id: user_id) }
    let(:token) { 'some-token' }
    let(:user_id) { 1 }
    let(:id) { 1 }

    before do
      users.insert(email: email, password: encrypted_password, id: id)
      allow(SecureRandom).to receive(:base64).and_return(token)
    end

    it "generates a token for the user" do
      expect(users.first[:token]).to be_nil
      subject
      expect(users.first[:token]).to eq(token)
    end

    it "returns the token" do
      expect(subject).to eq(token)
    end

    context "when user doesn't exist" do
      let(:user_id) { 2 }

      it "raises an error when a user isn't found" do
        expect{subject}.to raise_error(ModelNotFoundError)
      end
    end
  end

  describe "#authenticate" do
    subject { described_class.new.authenticate(email: email, password: password) }
    let(:id) { 1 }

    before do
      users.insert(email: email, password: encrypted_password, id: id)
    end

    it "returns the user id" do
      expect(subject).to eq(id)
    end

    context "when there's incorrect information" do
      subject { described_class.new.authenticate(email: 'somewrongemail@example.com', password: password) }

      it "raises model not found error" do
        expect{subject}.to raise_error ModelNotFoundError
      end
    end
  end
end
