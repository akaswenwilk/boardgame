FactoryBot.define do
  factory :player_board do
    to_create do |player_board|
      player_board.id = DB[:player_boards].insert(**player_board.attributes)
    end

    sequence :id do |n|
      n
    end

    game_id { nil }
    player_id { nil }
    playing_spaces { nil }
    negative_spaces { nil }
    ending_spaces { nil }
    points { 0 }

    initialize_with do
      params = {
        id: id,
        game_id: game_id,
        player_id: player_id,
        playing_spaces: playing_spaces,
        negative_spaces: negative_spaces,
        ending_spaces: ending_spaces,
        points: points
      }
      new(params)
    end
  end
end
