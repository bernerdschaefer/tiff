require "spec_helper"

describe Tiff::Image do
  let(:tempfile) { Tempfile.new("tiff") }

  describe "#initialize" do

    it "accepts a file path and file mode" do
      lambda { Tiff::Image.new tempfile.path, "w" }.should_not raise_exception
    end

    it "can open a file in read mode" do
      pending "Only writes are supported presently" do
        lambda { Tiff::Image.new tempfile.path, "r" }.should_not \
          raise_exception(ArgumentError)
      end
    end

    it "sets the path" do
      image = Tiff::Image.new tempfile.path, "w"
      image.path.should == tempfile.path
    end

    it "sets the file mode" do
      image = Tiff::Image.new tempfile.path, "w"
      image.mode.should == "w"
    end

  end

end
