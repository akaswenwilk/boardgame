RSpec.describe AuthenticationService do
  let(:token) { 'some-token' }
  let(:admin_only) { false }
  let(:user_repo_class) { UserRepo }
  let(:user_repo_double) { instance_double(user_repo_class) }
  let(:admin) { true }

  before do
    DB[:users].insert(email: 'someemail@example.com', password: '12345678', token: token, admin: admin)
    allow(user_repo_class).to receive(:new).and_return(user_repo_double)
    allow(user_repo_double).to receive(:find_by_token).with(token).and_return(DB[:users].first)
  end

  describe "#authenticate" do
    subject { described_class.new.authenticate(token: token, admin_only: admin_only) }

    it "returns true" do
      expect(subject).to eq(true)
    end

    it "finds a user by token" do
      expect(user_repo_double).to receive(:find_by_token)

      subject
    end

    context "when token is invalid" do
      let(:bad_token) { "invalid-token" }
      subject { described_class.new.authenticate(token: bad_token) }

      before do
        allow(user_repo_double).to receive(:find_by_token).with(bad_token).and_raise(ModelNotFoundError.new("some-error"))
      end

      it "raises an error if user isn't found" do
        expect{subject}.to raise_error(AuthenticationError)
      end
    end

    context "when admin is required" do
      let(:admin_only) { true }

      it "returns true" do
        expect(subject).to eq(true)
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
