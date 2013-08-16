Sequel.migration do
  up do
    alter_table(:images) do
      add_column :layer, Fixnum, :default => 0
    end
  end
end
