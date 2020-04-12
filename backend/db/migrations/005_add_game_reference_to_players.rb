Sequel.migration do
  change do
    alter_table(:players) do
      add_foreign_key :game_id, :games
    end
  end
end
