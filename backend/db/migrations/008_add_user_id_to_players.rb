Sequel.migration do
  change do
    alter_table(:players) do
      add_foreign_key :user_id, :users
    end
  end
end
