Sequel.migration do
  def up
    alter_table(:games) do
      set_column_type :playing_spaces, JSON
      set_column_type :ending_spaces, JSON
      set_column_type :negative_spaces, JSON
    end
  end

  def down
    alter_table(:games) do
      set_column_type :playing_spaces, String
      set_column_type :ending_spaces, String
      set_column_type :negative_spaces, String
    end
  end
end
