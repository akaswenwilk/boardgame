Sequel.migration do
  change do
    alter_table(:games) do
      add_column :used_tiles, JSON
    end
  end
end
