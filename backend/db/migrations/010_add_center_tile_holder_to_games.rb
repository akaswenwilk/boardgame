Sequel.migration do
  change do
    alter_table(:games) do
      add_column :center_tile_holder, JSON
    end
  end
end
