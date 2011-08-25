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
