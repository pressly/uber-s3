class UberS3
  module Connection
    
    def self.open(s3, options={})
      adapter = options.delete(:adapter) || :net_http      
      
      begin
        require "uber-s3/connection/#{adapter}"
        klass = instance_eval(adapter.to_s.split('_').map {|x| x.capitalize}.join(""))
      rescue LoadError
        raise "Cannot load #{adapter} adapter class"
      end
      
      klass.new(s3, options)
    end
    
    
    class Adapter
    
      attr_accessor :s3, :http, :uri, :access_key, :secret_access_key, :region, :defaults
    
      def initialize(s3, options={})
        self.s3                 = s3
        self.http               = nil
        self.uri                = nil
        self.access_key         = options[:access_key]
        self.secret_access_key  = options[:secret_access_key]
				self.region 					  = options[:region]
        self.defaults           = options[:defaults] || {}
      end
    
      [:get, :post, :put, :delete, :head].each do |verb|
        define_method(verb) do |*args|
          path, headers, body = args
          path = path.gsub(/^\//, '')
          headers ||= {}

          # Default headers
          headers['Date'] = Time.now.httpdate if !headers.keys.include?('Date')
          headers['User-Agent'] ||= "UberS3 v#{UberS3::VERSION}"
          headers['Connection'] ||= 'keep-alive'
          
          if body
            headers['Content-Length'] ||= body.bytesize.to_s
          end
          
          # Authorize the request          
          signature = Authorization.sign(s3, verb, path, headers)
          headers['Authorization'] = "AWS #{access_key}:#{signature}"
          
          # Make the request
					if self.region.blank?
						url = "http://#{s3.bucket}.s3.amazonaws.com/#{path}"
					else
						url = "http://#{s3.bucket}.s3-#{self.region}.amazonaws.com/#{path}"
					end

          request(verb, url, headers, body)
        end
      end

      def uri=(uri)
        # Reset the http connection if the host/port change
        if !@uri.nil? && !(uri.host == @uri.host && uri.port == @uri.port)
          self.http = nil
        end

        @uri = uri
      end

      def request(verb, url, headers={}, body=nil)
        raise "Abstract method"
      end

    end
    
  end  
end
