module Dagron
  class Map < Sequel::Model
    one_to_many :images

    protected

    def validate
      super

      validates_presence :name
      validates_unique :name
    end
  end
end
