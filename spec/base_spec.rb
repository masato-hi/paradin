RSpec.describe Paradin::Base do
  describe "#perform" do
    let(:instance) { Paradin::Base.new }

    context "when call method" do
      subject { -> { instance.perform } }

      it do
        is_expected.to raise_error(NoMethodError)
      end
    end

    context "when call private method invocation" do
      subject { -> { instance.send(:perform) } }

      it do
        is_expected.to raise_error(NotImplementedError)
      end
    end
  end
end
