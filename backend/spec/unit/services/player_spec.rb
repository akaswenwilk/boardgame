RSpec.describe PlayerService do
  let(:game) { build(:game) }
  let(:user) { build(:user) }

  before do
    game.id = DB[:games].insert
  end
  describe "#create" do
    subject { described_class.new.create(args) }
  end
end
