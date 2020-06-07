Sequel.migration do
  change do
    create_table(:games) do
      primary_key :id
      TrueClass :started, default: false
      String :winner_name
      foreign_key :current_player_id, :players
    end
  end
end
