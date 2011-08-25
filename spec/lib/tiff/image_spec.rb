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

end
