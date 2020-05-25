FactoryBot.define do
  factory :player do
    skip_create

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
