Tiff
====

This is a simple wrapper around libtiff using FFI. Presently, I only need to be
able to generate a TIFF image from raw data, so that's all of the API that's
been implemented. If you're interested in adding features, you can always send
me a pull request (please include specs!).

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

Extending
=========

As I mentioned, only a small subset of TIFF features are currently implemented.
It should, however, be pretty easy to add new support -- especially if you need
additional tag support.

You can add support for new tags from within your own application like this:

    # Add support for TIFFTAG_DOCUMENTNAME
    Tiff::Bindings.tags[:document_name] = Tiff::Tag.new(
      :document_name, 269, :string
    )

    # Add support for TIFFTAG_THRESHHOLDING
    Tiff::Bindings.tags[:threshholding] = Tiff::Tag.new(
      :threshholding, 263, :ushort, {
        :bilevel => 1,
        :halftone => 2,
        :error_diffuse => 3
      }
    )
