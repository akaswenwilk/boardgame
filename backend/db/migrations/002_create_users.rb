Sequel.migration do
  change do
    create_table(:users) do
      primary_key :id
      String :email, null: false
      String :password, null: false
      String :token
      TrueClass :admin, default: false
    end
  end
end
