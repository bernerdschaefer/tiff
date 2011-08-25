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

  end
end
