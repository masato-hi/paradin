
module Paradin
  class Base
    include Configuration
    include Task

    def initialize
      self.class.send(:private, :perform)
    end

    def perform(*args, **kwargs)
      raise NotImplementedError
    end
  end
end