RSpec.describe User do
  let(:user) { build(:user, email: email, password: password, id: id) }
  let(:email) { 'test@example.com' }
  let(:password) { '12345678' }
  let(:id) { nil }

  describe "#validate!" do
    subject { user.validate! }

    it "doesn't raise an error" do
      expect{ subject }.not_to raise_error
    end

    shared_examples "saved_user" do
      let(:id) { 1 }

      it "doesn't raise an error when saved" do
        expect{ subject }.not_to raise_error
      end
    end

    context "when email is invalid" do
      let(:email) { 'some-emailexample.com' }

      it "raises validation error" do
        expect{ subject }.to raise_error(ValidationError)
      end
      it_behaves_like "saved_user"
    end

    context "when password is not long enough" do
      let(:password) { '1234' }

      it "raises validation error" do
        expect{ subject }.to raise_error(ValidationError)
      end
      it_behaves_like "saved_user"
    end

    context "when password does not have at least one number" do
      let(:password) { 'password' }

      it "raises validation error" do
        expect{ subject }.to raise_error(ValidationError)
      end
      it_behaves_like "saved_user"
    end
  end
end
