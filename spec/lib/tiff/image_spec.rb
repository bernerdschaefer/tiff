require "spec_helper"

describe Tiff::Image do
  let(:file) { Tempfile.new("tiff") }
  let(:image) { Tiff::Image.new file.path, "w" }

  describe "#initialize" do

    it "accepts a file path and file mode" do
      lambda { Tiff::Image.new file.path, "w" }.should_not raise_exception
    end

    it "can open a file in read mode" do
      pending "Only writes are supported presently" do
        lambda { Tiff::Image.new file.path, "r" }.should_not \
          raise_exception(ArgumentError)
      end
    end

    it "opens the file for writing" do
      Tiff::Bindings.should_receive(:open).with(file.path, "w")
      Tiff::Image.new file.path, "w"
    end

    it "sets the path" do
      image.path.should == file.path
    end

    it "sets the file mode" do
      image.mode.should == "w"
    end

    it "sets the file descriptor" do
      image = Tiff::Image.new file.path, "w"
      image.fd.should_not be_nil
    end

  end

  describe "#close" do

    it "closes the file descriptor" do
      Tiff::Bindings.should_receive(:close).with(image.fd)
      image.close
    end

  end

  describe "#data=" do

    it "writes the raw data" do
      data = "\x01\x00"

      Tiff::Bindings.should_receive(:write_raw_strip).with(
        image.fd, 0, data, data.length
      )

      image.data = data
    end

  end

  describe "#set_field" do
    context "when field is not supported" do

      it "raises an error" do
        lambda do
          image.set_field(:unsupported, 100)
        end.should raise_exception
      end

    end

    context ":width" do
      let(:width) { 277 }

      it "sets the image's width" do
        Tiff::Bindings.should_receive(:set_field).with(
          image.fd, 256, :uint, width
        )
        image.set_field :width, width
      end
    end

    context ":height" do
      let(:height) { 42 }

      it "sets the image's height" do
        Tiff::Bindings.should_receive(:set_field).with(
          image.fd, 257, :uint, height
        )
        image.set_field :height, height
      end
    end

    context ":bits_per_sample" do

      it "sets the image's bits per sample" do
        Tiff::Bindings.should_receive(:set_field).with(
          image.fd, 258, :ushort, 1
        )
        image.set_field :bits_per_sample, 1
      end

    end
  end

  describe "#width=" do
    it "sets the width field" do
      image.should_receive(:set_field).with(:width, 100)
      image.width = 100
    end
  end

  describe ".open" do

    it "initializes a new image" do
      Tiff::Image.should_receive(:new).with(file.path, "w")
      Tiff::Image.open file.path, "w"
    end

    it "returns the new image" do
      image = stub
      Tiff::Image.stub(:new => image)
      Tiff::Image.open(file.path, "w").should eq image
    end

    context "when passed a block" do

      it "yields the block" do
        called = false
        Tiff::Image.open(file.path, "w") do |image|
          called = true
        end
        called.should be_true
      end

      it "closes the image" do
        image = stub
        image.should_receive(:close)
        Tiff::Image.stub(:new => image)
        Tiff::Image.open(file.path, "w") do |image|
        end
      end

      context "when an error occurs in the block" do
        it "still closes the image" do
          image = stub
          image.should_receive(:close)
          Tiff::Image.stub(:new => image)
          lambda do
            Tiff::Image.open(file.path, "w") do |image|
              raise
            end
          end.should raise_exception
        end
      end

    end

  end

end
