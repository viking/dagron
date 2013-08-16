Sequel.migration do
  up do
    alter_table :maps do
      set_column_default :viewport_w, 100
      set_column_default :viewport_h, 100
    end
  end
end
