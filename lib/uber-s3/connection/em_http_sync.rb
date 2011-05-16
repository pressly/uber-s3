require 'eventmachine'
require 'em-http'
require 'em-synchrony'
require 'em-synchrony/em-http'

module UberS3::Connection
  class EmHttpSync < Adapter
    
    def request(verb, url, headers={}, body=nil)
      params = {}
      params[:head] = headers
      params[:body] = body if body
    
      r = EM::HttpRequest.new(url).send(verb, params)
      
      {
        :status => r.response_header.status,
        :header => r.response_header,
        :body   => r.response
      }
    end
    
  end
end
