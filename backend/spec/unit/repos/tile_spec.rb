RSpec.describe TileRepo do
  let(:tiles) { DB[:tiles] }
  let(:game_id) { 1 }

  before do
    DB[:games].insert(id: game_id)
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
      expect(colors.sort).to eq([*TileRepo::COLORS, TileRepo::FIRST].sort)
    end

    it "only creates one first player tile" do
      subject
      expect(tiles.where(color: TileRepo::FIRST).count).to eq(1)
    end
  end
end
