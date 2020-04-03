RSpec.describe Paradin::Task do
  describe "#enqueue" do
    class TaskEnqueueSpecSubject < Paradin::Base
    end

    let(:instance) { TaskEnqueueSpecSubject.new }

    it do
      instance.enqueue(1)
      instance.enqueue(a: 1)
      instance.enqueue(1, b: 2)
      expect(instance.send(:context_queue).size).to eq(3)
    end
  end

  describe "#async" do
    class TaskAsyncSpecSubject < Paradin::Base
      def perform(x)
      end
    end

    let(:instance) { TaskAsyncSpecSubject.new }

    before do
      instance.enqueue(1)
    end

    context "when using rails" do
      subject { -> { instance.async } }

      before do
        allow_any_instance_of(TaskAsyncSpecSubject).to(
          receive(:rails?)
          .and_return(true)
        )
      end

      it do
        is_expected.to raise_error(Paradin::NotSupported)
      end
    end

    context "when not using rails" do
      subject { instance.async }

      before do
        allow_any_instance_of(TaskAsyncSpecSubject).to(
          receive(:rails?)
          .and_return(false)
        )
      end

      specify do
        expect(subject.size).to eq(1)
        expect(subject.first).to be_kind_of(Concurrent::Promises::Future)
      end
    end
  end

  describe "#await" do
    context "when common case" do
      class TaskAwaitCommonCaseSpecSubject < Paradin::Base
        def perform(x)
          x * x
        end
      end

      subject { instance.await }

      let(:instance) { TaskAwaitCommonCaseSpecSubject.new }

      before do
        instance.enqueue(1)
        instance.enqueue(2)
      end

      context "when using rails" do
        before do
          allow_any_instance_of(TaskAwaitCommonCaseSpecSubject).to(
            receive(:rails?)
            .and_return(true)
          )
        end

        specify do
          expect(subject.size).to eq(2)
          expect(subject).to eq([1, 4])
        end
      end

      context "when not using rails" do
        before do
          allow_any_instance_of(TaskAwaitCommonCaseSpecSubject).to(
            receive(:rails?)
            .and_return(false)
          )
        end

        specify do
          expect(subject.size).to eq(2)
          expect(subject).to eq([1, 4])
        end
      end
    end

    context "when timeout" do
      class TaskAwaitTimeoutSpecSubject < Paradin::Base
        timeout 1

        def perform(_)
          sleep 2
        end
      end

      subject { -> { instance.await } }

      let(:instance) { TaskAwaitTimeoutSpecSubject.new }

      before do
        instance.enqueue(1)

        allow_any_instance_of(TaskAwaitTimeoutSpecSubject).to(
          receive(:rails?)
          .and_return(false)
        )
      end

      it do
        is_expected.to raise_error(Paradin::Timeout)
      end
    end

    context "when pass kwargs" do
      class TaskAwaitPassKwargsSpecSubject < Paradin::Base
        def perform(x:, y:)
          x + y
        end
      end

      subject { instance.await }

      let(:instance) { TaskAwaitPassKwargsSpecSubject.new }

      before do
        instance.enqueue(x: 1, y: 2)
        instance.enqueue(x: 3, y: 4)

        allow_any_instance_of(TaskAwaitPassKwargsSpecSubject).to(
          receive(:rails?)
          .and_return(false)
        )
      end

      specify do
        expect(subject.size).to eq(2)
        expect(subject).to eq([3, 7])
      end
    end
  end
end
