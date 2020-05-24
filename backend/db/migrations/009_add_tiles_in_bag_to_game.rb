Sequel.migration do
  change do
    alter_table(:games) do
      add_column :tiles_in_bag, JSON
    end
  end
end
