Sequel.migration do
  up do
    create_table :maps do
      primary_key :id
      String :name
      String :filename
      Blob :data
      DateTime :created_at
      DateTime :updated_at
    end
  end
end
