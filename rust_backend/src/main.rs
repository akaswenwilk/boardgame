use warp::Filter;

mod service;

#[tokio::main]
async fn main() {
    let app = 
        // GET /
        warp::path::end().map(|| "Hello, World!")
        // POST /users
        .or(warp::post().and(warp::path!("users")).map(|| service::create_user::call()))
        // POST /users/login
        .or(warp::post().and(warp::path!("users" / "login")).map(|| service::login_user::call()))
        // POST /games
        .or(warp::post().and(warp::path!("games")).map(|| service::create_game::call()))
        // GET /games
        .or(warp::path!("games").map(|| service::index_games::call()))
        // GET /games/:game_id/players
        .or(warp::path!("games" / String / "players").map(|game_id| service::index_players::call(game_id)))
        // POST /games/:game_id/start
        .or(warp::post().and(warp::path!("games" / String / "start")).map(|game_id| service::start_game::call(game_id)))
        // POST /games/:game_id/players/:player_id/possible_moves
        .or(warp::post().and(warp::path!("games" / String / "players" / String / "possible_moves")).map(|game_id, player_id| service::calculate_possible_moves::call(game_id, player_id)))
        // POST /games/:game_id/players/:player_id/move
        .or(warp::post().and(warp::path!("games" / String / "players" / String / "move")).map(|game_id, player_id| service::make_move::call(game_id, player_id)))
        // DELETE /games/:game_id
        .or(warp::delete().and(warp::path!("games" / String)).map(|game_id| service::delete_game::call(game_id)))
        // GET /games/:game_id
        .or(warp::path!("games" / String).map(|game_id| service::get_game::call(game_id)));

    warp::serve(app)
        .run(([127, 0, 0, 1], 3030))
        .await;
}