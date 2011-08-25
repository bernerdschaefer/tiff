require "spec_helper"

describe Tiff::Bindings do

  context "class methods" do
    let(:bindings) { Tiff::Bindings }
    subject { bindings }

    it { should respond_to :open }
    it { should respond_to :close }
    it { should respond_to :set_field }
    it { should respond_to :get_field }
    it { should respond_to :write_raw_strip }

    context "tags" do
      subject { bindings.tags }

      it { should be_a_kind_of Hash }

      context "when tag does not exist" do

        it "raises a KeyError" do
          lambda { subject[:abc] }.should raise_exception(KeyError)
        end

        it "informs the user of support tags" do
          lambda { subject[:abc] }.should \
            raise_exception(/#{Regexp.escape(subject.keys.inspect)}/)
        end

      end

      context ":width" do
        subject { bindings.tags[:width] }

        it "should have id 256" do
          subject.id.should eq 256
        end

        it "should have type :uint" do
          subject.type.should eq :uint
        end
      end

      context ":height" do
        subject { bindings.tags[:height] }

        it "should have id 257" do
          subject.id.should eq 257
        end

        it "should have type :uint" do
          subject.type.should eq :uint
        end
      end

      context ":bits_per_sample" do
        subject { bindings.tags[:bits_per_sample] }

        it "should have id 258" do
          subject.id.should eq 258
        end

        it "should have type :ushort" do
          subject.type.should eq :ushort
        end
      end

      context ":compression" do
        subject { bindings.tags[:compression] }

        it "should have id 259" do
          subject.id.should eq 259
        end

        it "should have type :ushort" do
          subject.type.should eq :ushort
        end

        it "should map :CCITTFAX3 to 3" do
          subject.map[:CCITTFAX3].should eq 3
        end

        it "should map :CCITTFAX4 to 4" do
          subject.map[:CCITTFAX4].should eq 4
        end
      end

      context ":photometric" do
        subject { bindings.tags[:photometric] }

        it "should have id 262" do
          subject.id.should eq 262
        end

        it "should have type :ushort" do
          subject.type.should eq :ushort
        end

        it "should map :min_is_white to 0" do
          subject.map[:min_is_white].should eq 0
        end

        it "should map :min_is_black to 1" do
          subject.map[:min_is_black].should eq 1
        end
      end

    end
  end

end
