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
      expect(subject.winner_name).to eq(nil)
      expect(subject.current_player_id).to eq(nil)
      expect(subject.tiles_in_bag).to eq([])
      expect(subject.center_tile_holder).to be_an_instance_of(TileHolder)
      expect(subject.center_tile_holder.tiles).to eq([])
      expect(subject.outside_tile_holders).to eq([])
    end
  end

  describe "#find" do
    subject { described_class.new.find(game_id) }

    let(:game_id) { 1 }

    before do
      games.insert(id: game_id)
    end

    it "returns a game instance with proper id" do
      expect(subject).to be_an_instance_of(Game)
      expect(subject.id).to eq(game_id)
    end
  end
end
