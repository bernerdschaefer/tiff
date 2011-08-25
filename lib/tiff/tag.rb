module Tiff
  class Tag

    # The name of this tag
    attr_accessor :name

    # The value for this tag as defined by `tiff.h`
    attr_accessor :id

    # The FFI type for this tag. See `man TIFFSetField` for the types of each
    # field, and `https://github.com/ffi/ffi/wiki/Types` for it's corresponding
    # value in ruby.
    attr_accessor :type

    # A hash of ruby to FFI values for serialization and deserialization.
    attr_accessor :map

    # Creates a new tag.
    #
    # - name: A rubyish name for the tag. Displayed to users for exceptions.
    # - id: The value for this tag as defined by `tiff.h`
    # - type: The FFI type of the tag
    # - map: A hash of ruby to FFI values (optional)
    #
    # Examples:
    #
    #   width = Tag.new(:width, 256, :uint)
    #   metric = Tag.new(:photometric, 262, :ushort, {
    #     min_is_white: 0,
    #     min_is_black: 1
    #   })
    #
    def initialize(name, id, type, map = nil)
      @name = name
      @id = id
      @type = type
      @map = map
    end

    # Returns the value for serialization. If the tag does not have a map
    # defined, this simply returns the value provided.
    #
    # If a map was provided for the tag, it will return the value for the
    # mapping. If the mapping isn't found, it will raise an exception.
    def serialize(value)
      return value unless map

      map.fetch value do
        raise KeyError, "Tag #{name.inspect} does not support value #{value.inspect}. Defined values: #{map.keys}"
      end
    end

    # Returns the deserialized value from the provided FFI::MemoryPointer.
    #
    # If a map was provided for the tag, it will return the ruby value if it
    # exists. If the mapping isn't found, it will return the raw value.
    def deserialize(pointer)
      value = pointer.send :"read_#{type}"
      value = map.invert[value] if map && map.has_value?(value)
      value
    end

  end
end
