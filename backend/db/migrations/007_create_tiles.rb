Sequel.migration do
  change do
    create_table(:tiles) do
      primary_key :id
      foreign_key :game_id, :games
      String :pattern
    end
  end
end
