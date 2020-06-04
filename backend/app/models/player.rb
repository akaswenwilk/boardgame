class Player
  attr_accessor :id, :game_id, :name, :user_id, :player_board

  def initialize(args = {})
    args = args&.with_indifferent_access
    @id = args.fetch(:id, nil)
    @game_id = args.fetch(:game_id, nil)
    @name = args.fetch(:name, nil)
    @user_id = args.fetch(:user_id, nil)
  end

  def attributes
    {
      id: id,
      game_id: game_id,
      name: name,
      user_id: user_id
    }.compact
  end
end
