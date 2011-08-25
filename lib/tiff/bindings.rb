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

    attach_function :get_field, :TIFFGetField,
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

    tags[:artist] = Tag.new(:artist, 315, :string)
    tags[:bad_fax_lines] = Tag.new(:bad_fax_lines, 326, :uint)
    tags[:bits_per_sample] = Tag.new(:bits_per_sample, 258, :ushort)
    tags[:clean_fax_data] = Tag.new(:clean_fax_data, 327, :ushort)
    tags[:compression] = Tag.new(:compression, 259, :ushort, CCITTFAX3: 3, CCITTFAX4: 4)
    tags[:consecutive_bad_fax_lines] = Tag.new(:consecutive_bad_fax_lines, 328, :uint)
    tags[:copyright] = Tag.new(:copyright, 33432, :string)
    tags[:data_type] = Tag.new(:data_type, 32996, :ushort)
    tags[:date_time] = Tag.new(:date_time, 306, :string)
    tags[:document_name] = Tag.new(:document_name, 269, :string)
    tags[:fill_order] = Tag.new(:fill_order, 266, :ushort)
    tags[:group3_options] = Tag.new(:group3_options, 292, :uint)
    tags[:group4_options] = Tag.new(:group4_options, 293, :uint)
    tags[:height] = Tag.new(:height, 257, :uint)
    tags[:host_computer] = Tag.new(:host_computer, 316, :string)
    tags[:image_depth] = Tag.new(:image_depth, 32997, :uint)
    tags[:image_description] = Tag.new(:image_description, 270, :string)
    tags[:ink_names] = Tag.new(:ink_names, 333, :string)
    tags[:ink_set] = Tag.new(:ink_set, 332, :ushort)
    tags[:make] = Tag.new(:make, 271, :string)
    tags[:matteing] = Tag.new(:matteing, 32995, :ushort)
    tags[:max_sample_value] = Tag.new(:max_sample_value, 281, :ushort)
    tags[:min_sample_value] = Tag.new(:min_sample_value, 280, :ushort)
    tags[:model] = Tag.new(:model, 272, :string)
    tags[:orientation] = Tag.new(:orientation, 274, :ushort)
    tags[:page_name] = Tag.new(:page_name, 285, :string)
    tags[:photometric] = Tag.new(:photometric, 262, :ushort, min_is_white: 0, min_is_black: 1)
    tags[:predictor] = Tag.new(:predictor, 317, :ushort)
    tags[:resolution_unit] = Tag.new(:resolution_unit, 296, :ushort, none: 1, inch: 2, centimeter: 3)
    tags[:rows_per_strip] = Tag.new(:rows_per_strip, 278, :uint)
    tags[:s_max_sample_value] = Tag.new(:s_max_sample_value, 341, :double)
    tags[:s_min_sample_value] = Tag.new(:s_min_sample_value, 340, :double)
    tags[:sample_format] = Tag.new(:sample_format, 339, :ushort)
    tags[:samples_per_pixel] = Tag.new(:samples_per_pixel, 277, :ushort)
    tags[:software] = Tag.new(:software, 305, :string)
    tags[:sub_file_type] = Tag.new(:sub_file_type, 255, :uint)
    tags[:target_printer] = Tag.new(:target_printer, 337, :string)
    tags[:tile_depth] = Tag.new(:tile_depth, 32998, :uint)
    tags[:tile_length] = Tag.new(:tile_length, 323, :uint)
    tags[:tile_width] = Tag.new(:tile_width, 322, :uint)
    tags[:width] = Tag.new(:width, 256, :uint)
    tags[:x_position] = Tag.new(:x_position, 286, :float)
    tags[:x_resolution] = Tag.new(:x_resolution, 282, :float)
    tags[:y_cb_cr_positioning] = Tag.new(:y_cb_cr_positioning, 531, :ushort)
    tags[:y_position] = Tag.new(:y_position, 286, :float)
    tags[:y_resolution] = Tag.new(:y_resolution, 283, :float)

    # Array types are not yet supported.
    #
    # tags[:reference_black_white] = Tag.new(:reference_black_white, 532, :float*)
    # tags[:sto_nits] = Tag.new(:sto_nits, 37439, :double*)
    # tags[:strip_byte_counts] = Tag.new(:strip_byte_counts, 279, :uint*)
    # tags[:strip_offsets] = Tag.new(:strip_offsets, 273, :uint*)
    # tags[:tile_byte_counts] = Tag.new(:tile_byte_counts, 324, :uint*)
    # tags[:tile_offsets] = Tag.new(:tile_offsets, 324, :uint*)
    # tags[:white_point] = Tag.new(:white_point, 318, :float*)
    # tags[:y_cb_cr_coefficients] = Tag.new(:y_cb_cr_coefficients, 529, :float*)

  end
end
