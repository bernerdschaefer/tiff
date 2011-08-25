module Tiff

  class Image

    attr_reader :path, :mode

    def initialize(path, mode)
      unless mode == "w"
        raise ArgumentError, "Tiff::Image only supports `w` mode"
      end

      @path = path
      @mode = mode
    end

  end

end
