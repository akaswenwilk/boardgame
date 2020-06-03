class PlayerBoardRepo
  def initialize
    @model = DB[:player_boards]
  end

  def create(player:, game:)
    player_board = PlayerBoard.new({
      game_id: game.id,
      player_id: player.id
    })
    player_board.id = @model.insert(**player_board.attributes)
    player.player_board = player_board
  end
end
