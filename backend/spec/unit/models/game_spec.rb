RSpec.describe User do
  let(:game) { build(:game) }

  describe "#push_outside_tile_holders" do
    subject { game.push_outside_tile_holders(n) }

    context "when there are two players" do
      let(:n) { 2 }

      it "creates 5 tiles in outside tile holders" do
        expect{ subject }.to change{ game.outside_tile_holders.count }.by(5)
      end
    end

    context "when there are three players" do
      let(:n) { 3 }

      it "creates 7 tiles in outside tile holders" do
        expect{ subject }.to change{ game.outside_tile_holders.count }.by(7)
      end
    end

    context "when there are four players" do
      let(:n) { 4 }

      it "creates 9 tiles in outside tile holders" do
        expect{ subject }.to change{ game.outside_tile_holders.count }.by(9)
      end
    end

    context "when there are five players" do
      let(:n) { 5 }

      it "creates nothing" do
        expect{ subject }.not_to change{ game.outside_tile_holders.count }
      end
    end

    context "when there is one players" do
      let(:n) { 1 }

      it "creates nothing" do
        expect{ subject }.not_to change{ game.outside_tile_holders.count }
      end
    end

    context "when there are too few players for already existing" do
      let(:n) { 2 }

      before do
        game.push_outside_tile_holders(3)
      end

      it "creates nothing" do
        expect{ subject }.not_to change{ game.outside_tile_holders.count }
      end

    end

    context "when there are three players after already having been called for two players" do
      let(:n) { 4 }

      before do
        game.push_outside_tile_holders(3)
      end

      it "creates 9 tiles in outside tile holders" do
        expect{ subject }.to change{ game.outside_tile_holders.count }.by(2)
      end
    end
  end
end
