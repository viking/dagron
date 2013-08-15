Sequel.migration do
  up do
    alter_table(:images) do
      add_column :visible, TrueClass, :default => true
    end
  end
end
