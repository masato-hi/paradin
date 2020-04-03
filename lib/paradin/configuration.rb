
module Paradin
  module Configuration
    DEFAULT_MAX_THREADS = 1

    def self.included(base)
      base.extend(ClassMethods)
    end

    module ClassMethods
      def timeout(seconds = nil)
        if seconds
          @timeout = seconds
        else
          @timeout
        end
      end

      def max_threads(count = nil)
        if count
          @max_threads = count
        else
          @max_threads || DEFAULT_MAX_THREADS
        end
      end
    end

    def timeout
      self.class.timeout
    end

    def max_threads
      self.class.max_threads
    end
  end
end