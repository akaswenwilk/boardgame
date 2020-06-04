FactoryBot.define do
  factory :game do
    to_create do |game|
      game.id = DB[:games].insert(**game.attributes)
    end

    transient do
      user { nil }
      players { 0 }
      populated { false }
    end

    sequence :id do |n|
      n
    end

    started { false }
    winner_id { nil }
    current_player_id { nil }
    tiles_in_bag { nil }
    center_tile_holder { nil }
    outside_tile_holders { nil }

    initialize_with do
      params = {
        id: id,
        started: started,
        winner_id: winner_id,
        current_player_id: current_player_id,
        tiles_in_bag: tiles_in_bag,
        center_tile_holder: center_tile_holder,
        outside_tile_holders: outside_tile_holders,
      }
      new(params)
    end

    after(:create) do |game, evaluator|
      if evaluator.populated
        TileRepo.new.populate_game(game)
        DB[:games].where(id: game.id).update(**game.attributes)
      end

      if evaluator.user && evaluator.players > 0
        create_list(:player, evaluator.players, user_id: evaluator.user.id, game_id: game.id)
        game.push_outside_tile_holders(evaluator.players)
        DB[:games].where(id: game.id).update(**game.attributes)
      end
    end
  end
end
