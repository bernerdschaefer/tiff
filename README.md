Tiff
====

This is a simple wrapper around libtiff using FFI. It only implements a small
subset of libffi's features -- just enough to generate a TIFF image and read
back some of its data. If you're interested in adding features, you can always
send me a pull request (please include specs!).

Usage
=====

    Tiff::Image.open "filename.tif", "w" do |tiff|

      tiff.set_field :compression, :CCITTFAX4
      # or: tiff.set_field :compression, :CCITTFAX3

      tiff.set_field :photometric, :min_is_white
      # or: tiff.set_field :photometric, :min_is_black

      tiff.bits_per_sample = 1
      tiff.width = 200
      tiff.height = 40

      tiff.data = raw_data

    end

    image = Tiff::Image.open "filename.tif", "r"
    image.get_field :width  # => 200
    image.get_field :height # => 40
    image.pixels  # => [4278190335, 4278255360, 4294901760, …] (array of 32-bit integers representing ABGR pixels)
