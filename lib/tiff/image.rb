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

  end

end
