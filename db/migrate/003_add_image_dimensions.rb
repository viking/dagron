Sequel.migration do
  up do
    alter_table(:images) do
      add_column :width, Fixnum
      add_column :height, Fixnum
    end
  end
end
