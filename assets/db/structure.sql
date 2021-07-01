CREATE TABLE IF NOT EXISTS "players" (
        "id" SERIAL,
        "name" varchar(255) NOT NULL,
        "game_id" int,
        "user_id" int
);

CREATE TABLE IF NOT EXISTS "users" (
        "id" SERIAL,
        "email" varchar(255) NOT NULL UNIQUE,
        "password" varchar(255) NOT NULL,
        "token" varchar(255),
        "admin" boolean DEFAULT FALSE
);

CREATE TABLE IF NOT EXISTS "games" (
        "id" SERIAL,
        "started" boolean DEFAULT FALSE,
        "winner_name" varchar(255),
        "current_player_id" int UNIQUE,
        "tiles_in_bag" json,
        "center_tile_holder" json,
        "outside_tile_holders" json,
        "player_order" json,
        "used_tiles" json
);

CREATE TABLE IF NOT EXISTS "player_boards" (
        "id" SERIAL,
        "player_id" int UNIQUE,
        "game_id" int,
        "playing_spaces" json,
        "ending_spaces" json,
        "negative_spaces" json,
        "points" int DEFAULT 0
);

CREATE TABLE IF NOT EXISTS "tiles" (
        "id" SERIAL,
        "game_id" int,
        "color" varchar(255)
);
