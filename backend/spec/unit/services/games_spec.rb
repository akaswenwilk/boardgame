RSpec.describe GameService do
  let(:game_repo_class) { GameRepo }
  let(:game_repo_double) { instance_double(game_repo_class) }
  let(:game_id) { 1 }
  let(:tile_repo_class) { TileRepo }
  let(:tile_repo_double) { instance_double(tile_repo_class) }
  let(:tile_holder_repo_class) { TileHolderRepo }
  let(:tile_holder_repo_double) { instance_double(tile_holder_repo_class) }

  before do
    allow(game_repo_class).to receive(:new).and_return(game_repo_double)
    allow(game_repo_double).to receive(:create).and_return(game_id)
    allow(tile_repo_class).to receive(:new).and_return(tile_repo_double)
    allow(tile_repo_double).to receive(:populate_game)
    allow(tile_holder_repo_class).to receive(:new).and_return(tile_holder_repo_double)
    allow(tile_repo_double).to receive(:get_first_tile)
    allow(tile_holder_repo_double).to receive(:create_center_holder)
    allow(tile_holder_repo_double).to receive(:add_tiles)
  end

  describe "#create" do
    subject { described_class.new.create }

    it "creates a game" do
      expect(game_repo_double).to receive(:create).and_return(game_id)

      subject
    end

    it "creates tiles for the game" do
      expect(tile_repo_double).to receive(:populate_game).with(game_id)

      subject
    end

    it "returns game id" do
      expect(subject).to eq(game_id)
    end
  end
end
