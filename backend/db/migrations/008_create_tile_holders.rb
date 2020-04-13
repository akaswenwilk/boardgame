Sequel.migration do
  change do
    create_table(:tile_holders) do
      primary_key :id
      foreign_key :game_id, :games
      column :current_tiles, :jsonb
      TrueClass :center, default: false
    end
  end
end
