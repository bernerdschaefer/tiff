module Tiff

  class Image

    attr_reader :path, :mode

    # The file descriptor. This is an FFI::Pointer to the opened TIFF file.
    attr_reader :fd

    def initialize(path, mode)
      unless mode == "w"
        raise ArgumentError, "Tiff::Image only supports `w` mode"
      end

      @path = path
      @mode = mode

      @fd = Bindings::open path, mode
    end

    def close
      Bindings::close fd
    end

    # Writes raw data to the image.
    def data=(data)
      Bindings::write_raw_strip fd, 0, data, data.length
    end

    def set_field(name, value)
      tag = Bindings::tags[name]
      Bindings::set_field fd, tag.id, tag.type, tag.serialize(value)
    end

    class << self

      # Initializes a new image. If a block is provided, the image is yielded
      # and automatically closed.
      def open(path, mode)
        new(path, mode).tap do |image|
          if block_given?
            begin
              yield image
            ensure
              image.close
            end
          end
        end
      end

    end

  end

end
