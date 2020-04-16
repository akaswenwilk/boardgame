RSpec.describe TileHolderRepo do
  let(:game_id) { 1 }
  let(:tile_holders) { DB[:tile_holders] }

  before do
    DB[:games].insert(id: game_id)
  end

  describe "#create_center_holder" do
    subject { described_class.new.create_center_holder(game_id) }

    it "creates a tile holder" do
      expect{subject}.to change{tile_holders.count}.by(1)
    end

    it "creates a center tile holder" do
      subject

      expect(tile_holders.first[:center]).to be true
    end

    it "returns the id of the center tile" do
      id = subject

      expect(id).to eq(tile_holders.first[:id])
    end
  end

  describe "#add_tiles" do
    subject { described_class.new.add_tiles(tile_holder_id, tiles) }

    let(:tile_holder_id) { 1 }
    let(:tiles) { [DB[:tiles].first] }
    let(:stringified_tiles) do
      tiles.map { |t| t.transform_keys(&:to_s) }
    end

    let(:pre_existing_tiles) { [] }

    before do
      DB[:tiles].insert(game_id: game_id, color: "first")
      tile_holders.insert(game_id: game_id, id: tile_holder_id, current_tiles: pre_existing_tiles.to_json)
    end

    it "adds one tile to the current tiles" do
      subject

      expect(JSON(tile_holders.first[:current_tiles])).to eq(stringified_tiles)
    end

    context "when there are already tiles present" do
      let(:pre_existing_tiles) { tiles }

      it "doesn't overwrite existing tiles" do
        subject

        expect(JSON(tile_holders.first[:current_tiles])).to eq(stringified_tiles + stringified_tiles)
      end
    end

    context "when there are multiple tiles to add" do
      let(:tiles) { DB[:tiles].first(2) }

      before do
        DB[:tiles].insert(game_id: game_id, color: "blue")
      end

      it "adds all tiles" do
        subject

        expect(JSON(tile_holders.first[:current_tiles])).to eq(stringified_tiles)
        expect(JSON(tile_holders.first[:current_tiles]).length).to eq(2)
      end
    end
  end
end
