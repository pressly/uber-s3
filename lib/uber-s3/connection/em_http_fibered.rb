require 'eventmachine'
require 'em-http'
require 'em-synchrony'
require 'em-synchrony/em-http'

module UberS3::Connection
  class EmHttpFibered < Adapter
    
    def request(verb, url, headers={}, body=nil)
      params = {}
      params[:head] = headers
      params[:body] = body if body
      # params[:keepalive] = true if persistent # causing issues ...?

      retries = 2
      begin
        r = EM::HttpRequest.new(url, :inactivity_timeout => 10, :connect_timeout => 10).send(verb, params)

        UberS3::Response.new({
          :status => r.response_header.status,
          :header => r.response_header,
          :body   => r.response,
          :raw    => r
        })
      rescue Exception => e
        retries -= 1
        retry if retries >= 0
      end
    end
    
  end
end
