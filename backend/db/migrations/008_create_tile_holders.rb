Sequel.migration do
  change do
    create_table(:tile_holders) do
      primary_key :id
      foreign_key :game_id, :games
      String :current_tiles, default: [].to_json
      TrueClass :center, default: false
    end
  end
end
