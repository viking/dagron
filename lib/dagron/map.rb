module Dagron
  class Map < Sequel::Model
    protected

    def validate
      super

      validates_presence :name
      validates_unique :name
    end
  end
end
