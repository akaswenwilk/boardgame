FactoryBot.define do
  factory :game do
    skip_create

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
  end
end
