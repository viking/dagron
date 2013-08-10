Sequel.migration do
  up do
    create_table :maps do
      primary_key :id
      String :name
      Fixnum :viewport_x
      Fixnum :viewport_y
      Fixnum :viewport_w
      Fixnum :viewport_h
      DateTime :created_at
      DateTime :updated_at
    end
  end
end
