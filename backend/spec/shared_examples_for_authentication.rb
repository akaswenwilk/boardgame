RSpec.shared_examples "admin only endpoint" do
  context "when user is an admin" do
    let(:admin) { true }

    it "doesn't raise an error" do
      subject

      expect(last_response.status).not_to eq(403)
    end
  end

  context "when user is not an admin" do
    let(:admin) { false }

    it "raises an error" do
      subject

      expect(last_response.status).to eq(403)
    end
  end

  context "when user does not exist" do
    before do
      params.merge!({token: 'bad_token'})
    end

    it "raises an error" do
      subject

      expect(last_response.status).to eq(403)
    end
  end

  context "when there is no token" do
    before do
      params.delete(:token)
    end

    it "raises an error" do
      subject

      expect(last_response.status).to eq(403)
    end
  end
end

RSpec.shared_examples "authenticated endpoint" do
  context "when user is an admin" do
    let(:admin) { true }

    it "doesn't raise an error" do
      subject

      expect(last_response.status).not_to eq(403)
    end
  end

  context "when user is not an admin" do
    let(:admin) { false }

    it "doesn't raise an error" do
      subject

      expect(last_response.status).not_to eq(403)
    end
  end

  context "when user does not exist" do
    before do
      params.merge!({token: 'bad_token'})
    end

    it "raises an error" do
      subject

      expect(last_response.status).to eq(403)
    end
  end

  context "when there is no token" do
    before do
      params.delete(:token)
    end

    it "raises an error" do
      subject

      expect(last_response.status).to eq(403)
    end
  end
end
