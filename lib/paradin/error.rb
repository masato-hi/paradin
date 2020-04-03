
module Paradin
  class Error < StandardError; end
  class Timeout < Error; end
  class NotSupported < Error; end
end