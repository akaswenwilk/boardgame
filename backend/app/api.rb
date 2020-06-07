require_relative "../config/initializers/base.rb"

class Api < Hanami::API
  use Hanami::Middleware::BodyParser, :json
  use ErrorHandler

  get "/" do
    "Hello, world"
  end

  post "/users" do
    token = UserService.new.create(
      email: params[:email],
      password: params[:password],
      password_confirmation: params[:password_confirmation]
    )
    response_body = {
      token: token
    }.to_json

    [201, response_body]
  end

  post "/users/login" do
    token = UserService.new.login(
      email: params[:email],
      password: params[:password],
    )
    response_body = {
      token: token
    }.to_json

    [201, response_body]
  end

  post "/games" do
    AuthenticationService.new.authenticate(token: params[:token], admin_only: true)

    game = GameService.new.create

    [201, game.attributes.to_json]
  end

  post "/games/:game_id/players" do
    user = AuthenticationService.new.authenticate(token: params[:token])

    args = {
      name: params[:name],
      game_id: params[:game_id],
      user: user
    }

    player_id = PlayerService.new.create(args)

    response_body = {
      id: player_id
    }.to_json

    [201, response_body]
  end

  post "games/:game_id/start" do
    AuthenticationService.new.authenticate(token: params[:token], admin_only: true)

    game = GameService.new.start(params[:game_id])

    [200, game.attributes.to_json]
  end

  get "games/:game_id/players/:player_id/possible_moves" do
    game_id = params[:game_id]
    player_id = params[:player_id]
    tile_holder = params[:tile_holder]
    tile_holder = tile_holder.to_i unless tile_holder == 'center'
    color = params[:color]

    args = {
      game_id: game_id,
      player_id: player_id,
      tile_holder: tile_holder,
      color: color
    }

    raise InvalidParamsError.new("require both a tile_holder and a color in params") unless tile_holder && color
    raise InvalidParamsError.new("Color must be either #{Tile::COLORS.join(', ')}") unless Tile::COLORS.include?(color)

    possible_moves = GameService.new.possible_moves(**args)

    [200, possible_moves.to_json]
  end

  post "games/:game_id/players/:player_id/move" do
    AuthenticationService.new.authenticate(token: params[:token])

    game_id = params[:game_id]
    player_id = params[:player_id]
    tile_holder = params[:tile_holder]
    tile_holder = tile_holder.to_i unless tile_holder == 'center'
    color = params[:color]
    row = params[:row].to_i

    args = {
      game_id: game_id,
      player_id: player_id,
      tile_holder: tile_holder,
      color: color,
      row: row
    }

    raise InvalidParamsError.new("require both a tile_holder and a color and a row in params") unless tile_holder && color && row
    raise InvalidParamsError.new("Color must be either #{Tile::COLORS.join(', ')}") unless Tile::COLORS.include?(color)
    raise InvalidParamsError.new("row must be between 0 and 4") unless row >= 0 && row <= 4

    full_game = GameService.new.move(**args)

    [200, full_game.to_json]
  end

  delete "games/:game_id" do
    AuthenticationService.new.authenticate(token: params[:token], admin_only: true)

    game_id = params[:game_id]
    GameService.new.delete(game_id)

    [200, ""]
  end
end
