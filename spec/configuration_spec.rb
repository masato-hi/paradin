RSpec.describe Paradin::Configuration do
  describe "#timeout" do
    context "when set timeout" do
      class ConfigurationSetTimeoutSpecSubject < Paradin::Base
        timeout 5
      end

      specify do
        expect(ConfigurationSetTimeoutSpecSubject.timeout).to eq(5)
        expect(ConfigurationSetTimeoutSpecSubject.new.timeout).to eq(5)
      end
    end

    context "when not set timeout" do
      class ConfigurationNotSetTimeoutSpecSubject < Paradin::Base
      end

      specify do
        expect(ConfigurationNotSetTimeoutSpecSubject.timeout).to be_nil
        expect(ConfigurationNotSetTimeoutSpecSubject.new.timeout).to be_nil
      end
    end
  end

  describe "#max_threads" do
    context "when set max_threads" do
      class ConfigurationSetMaxThreadsSpecSubject < Paradin::Base
        max_threads 3
      end

      specify do
        expect(ConfigurationSetMaxThreadsSpecSubject.max_threads).to eq(3)
        expect(ConfigurationSetMaxThreadsSpecSubject.new.max_threads).to eq(3)
      end
    end

    context "when not set max_threads" do
      class ConfigurationNotSetMaxThreadsSpecSubject < Paradin::Base
      end

      specify do
        expect(ConfigurationNotSetMaxThreadsSpecSubject.max_threads).to eq(1)
        expect(ConfigurationNotSetMaxThreadsSpecSubject.new.max_threads).to eq(1)
      end
    end
  end
end
