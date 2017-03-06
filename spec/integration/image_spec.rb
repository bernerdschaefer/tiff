require "spec_helper"

describe Tiff::Image do
  let(:file) { Tempfile.new("tiff") }
  let(:writer) { Tiff::Image.new file.path, "w" }
  let(:reader) { Tiff::Image.new file.path, "r" }

  before do
    Tiff::Image.open file.path, "w" do |tiff|
      tiff.compression = :CCITTFAX4
      tiff.width = 277
      tiff.height = 41
      tiff.set_field :photometric, :min_is_black
      tiff.bits_per_sample = 1
      tiff.set_field :resolution_unit, :inch

      tiff.data = File.read "spec/support/ccittfax4.raw"

      tiff.set_field :document_name, "testing123"
    end
  end

  describe "resolution_unit" do
    subject { reader.get_field(:resolution_unit) }
    it { should eq :inch }
  end

  describe "width" do
    subject { reader.get_field(:width) }
    it { should eq 277 }
  end

  describe "height" do
    subject { reader.get_field(:height) }
    it { should eq 41 }
  end

  describe "bits_per_sample" do
    subject { reader.get_field(:bits_per_sample) }
    it { should eq 1 }
  end

  describe "compression" do
    subject { reader.get_field(:compression) }
    it { should eq :CCITTFAX4 }
  end

  describe "photometric" do
    subject { reader.get_field(:photometric) }
    it { should eq :min_is_black }
  end

  describe "document_name" do
    subject { reader.get_field(:document_name) }
    it { should eq "testing123" }
  end

  describe "pixels" do
    let(:pixels_file) { Tiff::Image.new("spec/support/pixels.tiff", "rb") }
    subject { pixels_file.pixels }
    it { should eq [0xFF0000FF, 0xFF00FF00, 0xFFFF0000, 0x00000000] }
  end

end
