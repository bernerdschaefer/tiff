module Tiff
  module Bindings

    extend FFI::Library

    ffi_lib 'libtiff'

    attach_function :open, :TIFFOpen,
      [:string, :string], :pointer

    attach_function :close, :TIFFClose,
      [:pointer], :void

    attach_function :set_field, :TIFFSetField,
      [:pointer, :uint, :varargs], :int

    attach_function :write_raw_strip, :TIFFWriteRawStrip,
      [:pointer, :uint, :pointer, :int], :int

    @@tags = Hash.new do |hash, key|
      raise KeyError, "Tag #{key.inspect} is unsupported. Available tags: #{hash.keys}"
    end

    class << self
      def tags
        @@tags
      end
    end

    tags[:width]  = Tag.new(:width, 256, :uint)
    tags[:height] = Tag.new(:height, 257, :uint)
    tags[:bits_per_channel] = Tag.new(:bits_per_channel, 258, :ushort)

    tags[:compression] = Tag.new(:compression, 259, :ushort,
      CCITTFAX3: 3,
      CCITTFAX4: 4
    )
    tags[:photometric] = Tag.new(:photometric, 262, :ushort,
      min_is_white: 0,
      min_is_black: 1
    )

  end
end
