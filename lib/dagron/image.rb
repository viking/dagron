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

    def before_save
      super

      case mime_type
      when "image/png"
        width, height = data[0x10..0x18].unpack('NN')
        set(:width => width, :height => height)
      end
    end
  end
end
