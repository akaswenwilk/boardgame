FactoryBot.define do
  factory :player do
    to_create do |player|
      player.id = DB[:players].insert(**player.attributes)
    end

    sequence :id do |n|
      n
    end

    game_id { nil }
    user_id { nil }
    name { 'captain america' }

    initialize_with do
      params = {
        id: id,
        game_id: game_id,
        user_id: user_id,
        name: name
      }
      new(params)
    end
  end
end
