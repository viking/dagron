Sequel.migration do
  up do
    create_table :images do
      primary_key :id
      String :name
      String :filename
      File :data
      DateTime :created_at
      DateTime :updated_at
      Fixnum :map_id
    end
  end
end
