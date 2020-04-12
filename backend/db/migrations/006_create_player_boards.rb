Sequel.migration do
  change do
    create_table(:player_boards) do
      primary_key :id
      foreign_key :player_id, :players
      foreign_key :game_id, :games
      column :playing_spaces, :jsonb
      column :ending_spaces, :jsonb
      column :negative_spaces, :jsonb
      Integer :points, default: 0
    end
  end
end
