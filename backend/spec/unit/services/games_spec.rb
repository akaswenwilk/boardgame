RSpec.describe GameService do
  let(:games) { DB[:games] }

  describe "#create" do
    subject { described_class.new.create }

    it "creates a game with tiles" do
      expect{subject}.to change{games.count}.by(1)
      expect(subject).to be_an_instance_of(Game)
      expect(subject.id).not_to be_nil
      expect(subject.started).to eq(false)
      expect(subject.winner_name).to eq(nil)
      expect(subject.current_player_id).to eq(nil)
      expect(subject.center_tile_holder).to be_an_instance_of(TileHolder)
    end

    it "populates everything with tiles" do
      expect(subject.center_tile_holder.tiles.length).to eq(1)
      expect(subject.center_tile_holder.tiles.first.color).to eq(Tile::FIRST)
      expect(subject.tiles_in_bag.length).to eq(100)
    end
  end
end
