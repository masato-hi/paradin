
module Paradin
  class Error < StandardError; end
  class Timeout < Error; end
  class NotSupoorted < Error; end
end