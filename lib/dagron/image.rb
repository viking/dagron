module Dagron
  class Image < Sequel::Model
    many_to_one :map

    def mime_type
      ext = filename[/\.(\w+)$/, 1]
      case ext
      when "png"
        "image/png"
      end
    end

    protected

    def validate
      super

      validates_presence [:name, :filename, :data, :map_id]
      validates_unique :name
    end
  end
end
