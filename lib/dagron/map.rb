module Dagron
  class Map < Sequel::Model
    one_to_many :images
    add_association_dependencies :images => :destroy

    protected

    def validate
      super

      validates_presence :name
      validates_unique :name
    end
  end
end
