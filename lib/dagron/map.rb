module Dagron
  class Map < Sequel::Model
    protected

    def validate
      super

      validates_presence [:name, :filename, :data]
      validates_unique :name
    end
  end
end
