Sequel.migration do
  up do
    create_table :maps do
      primary_key :id
      String :name
      Fixnum :viewport_x, :default => 0
      Fixnum :viewport_y, :default => 0
      Fixnum :viewport_w, :default => 0
      Fixnum :viewport_h, :default => 0
      DateTime :created_at
      DateTime :updated_at
    end
  end
end
