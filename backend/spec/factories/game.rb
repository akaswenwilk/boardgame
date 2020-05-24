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

    initialize_with do
      params = {
        id: id,
        started: started,
        winner_id: winner_id,
        current_player_id: current_player_id,
        tiles_in_bag: tiles_in_bag,
      }
      new(params)
    end
  end
end
