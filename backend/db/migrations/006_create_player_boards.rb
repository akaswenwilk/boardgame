Sequel.migration do
  change do
    create_table(:player_boards) do
      primary_key :id
      foreign_key :player_id, :players
      foreign_key :game_id, :games
      String :playing_spaces
      String :ending_spaces
      String :negative_spaces
      Integer :points, default: 0
    end
  end
end
