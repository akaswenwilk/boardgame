Sequel.migration do
  change do
    alter_table(:games) do
      add_column :player_order, JSON
    end
  end
end
