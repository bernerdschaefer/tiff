require "spec_helper"

describe Tiff::Bindings do

  context "class methods" do
    subject { Tiff::Bindings }

    it { should respond_to :open }
    it { should respond_to :close }
    it { should respond_to :set_field }
    it { should respond_to :write_raw_strip }
  end

end
