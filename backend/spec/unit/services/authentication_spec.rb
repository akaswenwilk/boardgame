RSpec.describe AuthenticationService do
  let(:token) { 'some-token' }
  let(:admin_only) { false }
  let(:admin) { true }

  before do
    DB[:users].insert(email: 'someemail@example.com', password: '12345678', token: token, admin: admin)
  end

  describe "#authenticate" do
    subject { described_class.new.authenticate(token: token, admin_only: admin_only) }

    it "returns a user" do
      expect(subject).to be_an_instance_of(User)
      expect(subject.token).to eq(token)
      expect(subject.admin).to eq(admin)
    end

    context "when token is invalid" do
      let(:bad_token) { "invalid-token" }
      subject { described_class.new.authenticate(token: bad_token) }

      it "raises an error if user isn't found" do
        expect{subject}.to raise_error(AuthenticationError)
      end
    end

    context "when admin is required" do
      let(:admin_only) { true }

    it "returns a user" do
      expect(subject).to be_an_instance_of(User)
      expect(subject.token).to eq(token)
      expect(subject.admin).to eq(admin)
    end

      context "when user isn't admin" do
        let(:admin) { false }

        it "raises an error if user isn't an admin" do
          expect{subject}.to raise_error(AuthenticationError)
        end
      end
    end
  end
end
