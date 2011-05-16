require 'eventmachine'
require 'em-http'

module UberS3::Connection
  class EmHttp < Adapter
    
    # NOTE: this will be very difficult to support
    # with our interface.. will need lots of work
    # perhaps will limit async capabilities to
    # fibered mode
    
  end
end
