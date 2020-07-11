class GameService
  def create
    game = game_repo.create
    tile_repo.populate_game(game)
    game_repo.update(game)
    game
  end

  def get_all_games
    games = game_repo.get_all
    games.each do |game|
      get_attributes_for_full_game(game)
    end
    games
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

    get_attributes_for_full_game(game)

    game
  end

  def possible_moves(game_id:, player_id:, tile_holder:, color:, user:)
    game = game_repo.find(game_id)

    args = {
      game: game,
      player_id: player_id,
      tile_holder: tile_holder,
      color: color
    }
    player = player_repo.find(player_id)

    raise ValidationError.new("Player does not belong to user") unless player.user_id == user.id

    valid_move_choice!(**args)
    player_board = player_board_repo.find_by_player(player_id)
    possible_rows = []

    5.times do |n|
      possible_rows << n if player_board.valid_move?(n, color)
    end

    { possible_rows: possible_rows }
  end

  def move(game_id:, player_id:, tile_holder:, color:, row:, user:)
    game = game_repo.find(game_id)

    args = {
      game: game,
      player_id: player_id,
      tile_holder: tile_holder,
      color: color
    }

    player = player_repo.find(player_id)

    raise ValidationError.new("Player does not belong to user") unless player.user_id == user.id

    valid_move_choice!(**args)
    player_board = player_board_repo.find_by_player(player_id)

    raise ValidationError.new("not a valid move") unless player_board.valid_move?(row, color)

    tiles = game.tiles_from_holder(tile_holder, color)
    player_board.add_tiles(tiles, row, game)

    player_board_repo.update(player_board)

    game.players = player_repo.all_by_game(game)
    game.players.each { |p| p.player_board = player_board_repo.find_by_player(p.id) }

    game_over = false
    if game.end_of_round?
      first_player = game.players.find { |p| p.player_board.negative_spaces.any? {|t| t.color == Tile::FIRST } }
      game.current_player_id = first_player.id
      game.players.each do |player|
        player.player_board.score_points(game)
        game_over ||= true if player.player_board.has_full_row?
      end
      game.distribute_tiles_to_outside_holders
    else
      game.increment_current_player
    end

    game.players.each do |player|
      player_board_repo.update(player.player_board)
    end

    if game_over
      game.players.each do |player|
        player.player_board.score_special_points
        player_board_repo.update(player.player_board)
      end
      players = game.players.map { |p| [p.player_board.points, p.id] }
      winner = players.max { |a, b| a[0] <=> b[0] }
      winner_name = winner[1]
      game.winner_name = winner_name.to_s
      if players.select { |p| p[0] == winner[0] }.count > 1
        game.winner_name = "tie"
      end
      game.started = false
    end

    game.players.each do |player|
      player_board_repo.update(player.player_board)
    end

    game_repo.update(game)

    game.full_attributes
  end

  def delete(game_id)
    game = game_repo.find(game_id)
    game_repo.make_current_player_nil(game)
    tile_repo.delete_all(game_id)
    player_board_repo.delete_all(game_id)
    player_repo.delete_all(game_id)
    game_repo.delete(game_id)
  end

  def get_full_game(game_id)
    game = game_repo.find(game_id)
    game.players = player_repo.all_by_game(game)
    game.players.each { |p| p.player_board = player_board_repo.find_by_player(p.id) }

    game
  end

  private

  def get_attributes_for_full_game(game)
    game.players = player_repo.all_by_game(game)
    game.players.each { |p| p.player_board = player_board_repo.find_by_player(p.id) }
  end

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
