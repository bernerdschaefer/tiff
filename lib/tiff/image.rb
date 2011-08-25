module Tiff

  class Image

    attr_reader :path, :mode

    # The file descriptor. This is an FFI::Pointer to the opened TIFF file.
    attr_reader :fd

    def initialize(path, mode)
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

    # Sets a field on the image, using the list of tags in
    # `Tiff::Bindings.tags`
    def set_field(name, value)
      tag = Bindings::tags[name]
      Bindings::set_field fd, tag.id, tag.type, tag.serialize(value)
    end

    # Gets a field from the image, using the list of tags in #
    # `Tiff::Bindings.tags`
    def get_field(name)
      tag = Bindings::tags[name]
      pointer = FFI::MemoryPointer.new tag.type
      result = Bindings::get_field fd, tag.id, :pointer, pointer
      if result == 1
        tag.deserialize pointer
      else
        nil
      end
    end

    # Sets the image's width
    def width=(width)
      set_field :width, width
    end

    # Sets the image's height
    def height=(height)
      set_field :height, height
    end

    # Sets the image's bits_per_sample
    def bits_per_sample=(bits_per_sample)
      set_field :bits_per_sample, bits_per_sample
    end

    # Sets the image's compression
    def compression=(compresion)
      set_field :compression, compresion
    end

    # Sets the image's photometric
    def photometric=(compresion)
      set_field :photometric, compresion
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
