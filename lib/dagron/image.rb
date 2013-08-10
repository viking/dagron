module Dagron
  class Image < Sequel::Model
    protected

    def validate
      super

      validates_presence [:name, :filename, :data, :map_id]
      validates_unique :name
    end
  end
end
