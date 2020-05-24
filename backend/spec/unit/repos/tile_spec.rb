RSpec.describe TileRepo do
  let(:tiles) { DB[:tiles] }
  let(:game) { build(:game) }

  before do
    DB[:games].insert(**game.attributes)
  end

  describe "#populate_game" do
    subject { described_class.new.populate_game(game_id) }

    it "creates 101 tiles total" do
      expect{subject}.to change{DB[:tiles].count}.from(0).to(101)
    end

    it "creates all tiles with game id" do
      subject
      expect(tiles.distinct(:game_id).count).to eq(1)
    end

    it "creates 20 of each tile" do
      subject
      colors = tiles.distinct(:color).order(:color).map{ |tile| tile[:color] }
      expect(colors.sort).to eq([*Tile::COLORS, Tile::FIRST].sort)
    end

    it "only creates one first player tile" do
      subject
      expect(tiles.where(color: Tile::FIRST).count).to eq(1)
    end
  end

  describe "#get_first_tile" do
    before do
      described_class.new.populate_game(game_id)
    end

    subject { described_class.new.get_first_tile(game_id) }

    it "returns the first player tile" do
      expect(subject).to be_an_instance_of(Tile)
      expect(subject.color).to eq(Tile::FIRST)
    end
  end
end
