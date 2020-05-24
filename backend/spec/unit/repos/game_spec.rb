RSpec.describe GameRepo do
  let(:games) { DB[:games] }
  describe "#create" do
    subject { described_class.new.create }

    it "creates a game" do
      expect{subject}.to change{games.count}.by(1)
    end

    it "returns the game with default values" do
      expect(subject).to be_an_instance_of(Game)
      expect(subject.id).not_to be_nil
      expect(subject.started).to eq(false)
      expect(subject.winner_id).to eq(nil)
      expect(subject.current_player_id).to eq(nil)
      expect(subject.tiles_in_bag).to eq([])
      expect(subject.center_tile_holder).to be_an_instance_of(TileHolder)
      expect(subject.center_tile_holder.tiles).to eq([])
      expect(subject.outside_tile_holders).to eq([])
    end
  end
end
