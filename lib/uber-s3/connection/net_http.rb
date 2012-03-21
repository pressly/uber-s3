require 'net/http'
require 'net/http/persistent'

module UberS3::Connection
  class NetHttp < Adapter
    
    def request(verb, url, headers={}, body=nil)
      if verb == :get
        # Support fetching compressed data
        headers['Accept-Encoding'] = 'gzip, deflate'
      end
      
      uri = URI.parse(url)

      if persistent
        http = Net::HTTP::Persistent.new("#{access_key}:#{client.bucket}")
      else
        http = Net::HTTP.new(uri.host, uri.port)
      end
      
      req_klass = instance_eval("Net::HTTP::"+verb.to_s.capitalize)
      req = req_klass.new(uri.to_s, headers)

      req.body = body if !body.nil? && !body.empty?
      
      if persistent
        r = http.request(uri, req)
      else
        r = http.request(req)
      end
      
      # Auto-decode any gzipped objects
      if verb == :get && r.header['content-encoding'] == 'gzip'
        gz = Zlib::GzipReader.new(StringIO.new(r.body))
        response_body = gz.read
      else
        response_body = r.body
      end
      
      UberS3::Response.new({
        :status => r.code.to_i,
        :header => r.header.to_hash,
        :body   => response_body,
        :raw    => r
      })
    end
    
  end
end
