RSpec.fdescribe PlayerRepo do
  let(:players) { DB[:players] }
  let(:game) { build(:game) }
  let(:user) { build(:user) }

  before do
    user.id = DB[:users].insert(**user.attributes(true))
    game.id = DB[:games].insert(**game.attributes)
  end

  describe "#create" do
    subject { described_class.new.create(**args) }

    let(:args) do
      {
        name: name,
        game: game,
        user: user
      }
    end

    let(:name) { "some-name" }

    it "creates a player" do
      expect{ subject }.to change{ players.count }.by(1)
      expect(subject).to be_an_instance_of(Player)
      expect(subject.game_id).to eq(game.id)
      expect(subject.user_id).to eq(user.id)
      expect(subject.name).to eq(name)
    end

    context "when there are already 4 players for the game" do
      let(:players_list) { build_list(:player, 4, game_id: game.id, user_id: user.id) }

      before do
        players_list.each do |player|
          players.insert(**player.attributes)
        end
      end

      it "raises an error" do
        expect{ subject }.to raise_error(ValidationError)
      end
    end
  end

  describe "#all_by_game" do
    subject { described_class.new.all_by_game(game) }

    let(:players_list) { build_list(:player, n, game_id: game.id, user_id: user.id) }

      before do
        players_list.each do |player|
          players.insert(**player.attributes)
        end
      end

    context "when there's only one player" do
      let(:n) { 1 }

      it "returns an array with one player" do
        expect(subject).to be_an_instance_of(Array)
        expect(subject.first).to be_an_instance_of(Player)
        expect(subject.length).to eq(1)
        expect(subject.first.id).not_to be_nil
      end
    end

    context "when there's four players" do
      let(:n) { 4 }

      it "returns an array with four players" do
        expect(subject).to be_an_instance_of(Array)
        expect(subject.length).to eq(4)
        subject.each do |p|
          expect(p).to be_an_instance_of(Player)
          expect(p.id).not_to be_nil
        end
      end
    end

    context "when there's no players" do
      let(:n) { 0 }

      it "returns an empty array" do
        expect(subject.length).to eq(0)
      end
    end
  end
end
