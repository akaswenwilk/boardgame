class GameService
  def create
    game = game_repo.create
    tile_repo.populate_game(game)
    game_repo.update(game)
    game
  end

  def start(game_id)
    game = game_repo.find(game_id)
    unless game.current_player_id
      game.started = true
      players = player_repo.all_by_game(game)
      raise ValidationError.new("Must have between 2 and 4 players") unless players.count >= 2 && players.count <= 4
      game.set_player_order(players)
      game.increment_current_player
      game.distribute_tiles_to_outside_holders

      game_repo.update(game)
    end

    game
  end

  def possible_moves(game_id:, player_id:, tile_holder:, color:)
    game = game_repo.find(game_id)

    args = {
      game: game,
      player_id: player_id,
      tile_holder: tile_holder,
      color: color
    }

    valid_move_choice!(**args)
    player_board = player_board_repo.find_by_player(player_id)
    possible_rows = []

    5.times do |n|
      possible_rows << n if player_board.valid_move?(n, color)
    end

    { possible_rows: possible_rows }
  end

  private

  def valid_move_choice!(game:, player_id:, tile_holder:, color:)
    raise ValidationError.new("Game must first be started") unless game.started
    raise ValidationError.new("not this player's turn") unless player_id == game.current_player_id&.to_s
    raise InvalidParamsError.new("Tile holder must be either center or between 0 and #{game.outside_tile_holders.length - 1}") if tile_holder != 'center' && tile_holder >= game.outside_tile_holders.length

    if tile_holder == 'center'
      selected_holder = game.center_tile_holder
    else
      selected_holder = game.outside_tile_holders[tile_holder]
    end

    raise ValidationError.new("selected tile holder does not have chosen color") unless selected_holder.tiles.any?{|tile| tile.color == color }
  end

  def game_repo
    @game_repo ||= GameRepo.new
  end

  def tile_repo
    @tile_repo ||= TileRepo.new
  end

  def tile_holder_repo
    @tile_holder_repo ||= TileHolderRepo.new
  end

  def player_repo
    @player_repo ||= PlayerRepo.new
  end

  def player_board_repo
    @player_board_repo ||= PlayerBoardRepo.new
  end
end
