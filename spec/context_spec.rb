RSpec.describe Paradin::Context do
  describe "#args" do
    subject { instance.args }

    let(:args) { [1, {a: 2}, "b"] }
    let(:instance) { described_class.new(*args) }

    context "when use marshal serializer" do
      before do
        allow_any_instance_of(described_class).to(
          receive(:use_active_job_serializer)
          .and_return(false)
        )
      end

      it do
        is_expected.to eq(args)
      end
    end

    context "when use active job arguments serializer" do
      before do
        allow_any_instance_of(described_class).to(
          receive(:use_active_job_serializer)
          .and_return(true)
        )
      end

      it do
        is_expected.to eq(args)
      end
    end
  end

  describe "#kawrgs" do
    subject { instance.kwargs }

    let(:kwargs) { {a: 1, b: {c: 2}} }
    let(:instance) { described_class.new(**kwargs) }

    context "when use marshal serializer" do
      before do
        allow_any_instance_of(described_class).to(
          receive(:use_active_job_serializer)
          .and_return(false)
        )
      end

      it do
        is_expected.to eq(kwargs)
      end
    end

    context "when use active job arguments serializer" do
      before do
        allow_any_instance_of(described_class).to(
          receive(:use_active_job_serializer)
          .and_return(true)
        )
      end

      it do
        is_expected.to eq(kwargs)
      end
    end
  end
end
