Sequel.migration do
  change do
    alter_table(:games) do
      add_column :outside_tile_holders, JSON
    end
  end
end
