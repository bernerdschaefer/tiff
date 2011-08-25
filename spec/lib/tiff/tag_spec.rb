require "spec_helper"

describe Tiff::Tag do

  describe "#initialize" do

    it "sets the id" do
      Tiff::Tag.new(:tag, 123, :uint).id.should eq 123
    end

    it "sets the type" do
      Tiff::Tag.new(:tag, 123, :uint).type.should eq :uint
    end

    context "map" do
      context "when not provided" do
        it "is nil" do
          Tiff::Tag.new(:tag, 123, :uint).map.should be_nil
        end
      end

      context "when provided" do
        it "equals the provided map" do
          Tiff::Tag.new(:tag, 123, :uint, {:a => 1}).map.should eq(a: 1)
        end
      end
    end

  end

  describe "#serialize" do

    context "when no map is provided" do
      let(:tag) do
        Tiff::Tag.new(:tag, 123, :uint)
      end

      it "returns the value unchanged" do
        tag.serialize(1).should eq 1
      end
    end

    context "when a map is provided" do
      let(:tag) do
        Tiff::Tag.new(:tag, 123, :uint, a: 1)
      end

      context "and the value is mapped" do
        it "returns the mapped value" do
          tag.serialize(:a).should eq 1
        end
      end

      context "and the value is not mapped" do
        it "raises a KeyError" do
          lambda { tag.serialize(:b) }.should raise_exception(KeyError)
        end

        it "informs the user of the available options" do
          lambda { tag.serialize(:b) }.should raise_exception(/:a/)
        end
      end

    end

  end

  describe "#deserialize" do
    let(:pointer) do
      FFI::MemoryPointer.new(:uint).tap do |pointer|
        pointer.write_uint 1
      end
    end

    context "when no map is provided" do
      let(:tag) do
        Tiff::Tag.new(:tag, 123, :uint)
      end

      it "returns the value" do
        tag.deserialize(pointer).should eq 1
      end
    end

    context "when a map is provided" do
      let(:tag) do
        Tiff::Tag.new(:tag, 123, :uint, a: 1)
      end

      context "and the value is mapped" do
        it "returns the mapped value" do
          tag.deserialize(pointer).should eq :a
        end
      end

      context "and the value is not mapped" do
        it "raises a KeyError" do
          lambda { tag.serialize(:b) }.should raise_exception(KeyError)
        end

        it "informs the user of the available options" do
          lambda { tag.serialize(:b) }.should raise_exception(/:a/)
        end
      end

    end

  end

end
