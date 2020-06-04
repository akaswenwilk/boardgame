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
end
