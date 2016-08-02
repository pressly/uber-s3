require 'net/http'

module UberS3::Connection
  class NetHttp < Adapter
    
    def request(verb, url, headers={}, body=nil)
      options = self.request_options
      if verb == :get
        # Support fetching compressed data
        headers['Accept-Encoding'] = 'gzip, deflate'
      end
      
      self.uri = URI.parse(url)

      # Init and open a HTTP connection
      http_connect! if http.nil? || !http.started?

      req_klass = instance_eval("Net::HTTP::"+verb.to_s.capitalize)
      req = req_klass.new(uri.to_s, headers)

      req.body = body if !body.nil? && !body.empty?

      # Make HTTP request
      retries = options.fetch(:num_retries, 2)
      begin
        r = http.request(req)
      rescue EOFError, Errno::EPIPE => e
        # Something happened to our connection, lets try this again
        http_connect!
        if retries.present?
          retries -= 1
          retry if retries >= 0
        else
          raise e
        end
      end

      # Auto-decode any gzipped objects
      if verb == :get && r.header['Content-Encoding'] == 'gzip'
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
    
    def reconnect!
      http.finish if http && http.started?
      http_connect!
    end

    private

      def http_connect!
        self.http = Net::HTTP.new(uri.host, uri.port)
        
        http.open_timeout = http_options[:open_timeout].to_f if http_options.has_key?(:open_timeout)
        http.read_timeout = http_options[:read_timeout].to_f if http_options.has_key?(:read_timeout)
        
        http.start

        if Socket.const_defined?(:TCP_NODELAY)
          socket = http.instance_variable_get(:@socket)
          socket.io.setsockopt(Socket::IPPROTO_TCP, Socket::TCP_NODELAY, true)
        end
      end
    
  end
end
