RSpec.describe GameRepo do
  let(:games) { DB[:games] }
  describe "#create" do
    subject { described_class.new.create }

    it "creates a game" do
      expect{subject}.to change{games.count}.by(1)
    end

    it "returns the new game id" do
      expect(subject).to eq(games.first[:id])
    end

    it "sets default values for game" do
      subject

      expect(games.first[:started]).to eq(false)
      expect(games.first[:winner_id]).to eq(nil)
      expect(games.first[:current_player_id]).to eq(nil)
    end
  end
end
