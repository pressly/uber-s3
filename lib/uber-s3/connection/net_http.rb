require 'net/http'

module UberS3::Connection
  class NetHttp < Adapter
    
    def request(verb, url, headers={}, body=nil)
      uri = URI.parse(url)
      http = Net::HTTP.new(uri.host, uri.port)
      
      req_klass = instance_eval("Net::HTTP::"+verb.to_s.capitalize)
      req = req_klass.new(uri.to_s, headers)
            
      r = http.request(req, body)
      
      {
        :status => r.code.to_i,
        :header => r.header.to_hash,
        :body   => r.body
      }
    end
    
  end
end
