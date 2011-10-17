class UberS3
  module Connection
    
    def self.open(client, options={})
      adapter = options.delete(:adapter) || :net_http      
      
      begin
        require "uber-s3/connection/#{adapter}"
        klass = instance_eval(adapter.to_s.split('_').map {|x| x.capitalize}.join(""))
      rescue LoadError
        raise "Cannot load #{adapter} adapter class"
      end
      
      klass.new(client, options)
    end
    
    
    class Adapter
    
      attr_accessor :client, :access_key, :secret_access_key, :persistent, :defaults
    
      def initialize(client, options={})
        self.client             = client
        self.access_key         = options[:access_key]
        self.secret_access_key  = options[:secret_access_key]
        self.persistent         = options[:persistent] || true
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
          # headers['Connection'] = (persistent ? 'keep-alive' : 'close')
          
          if body
            headers['Content-Length'] ||= body.bytesize.to_s
          end
          
          # Authorize the request          
          signature = Authorization.sign(client, verb, path, headers)
          headers['Authorization'] = "AWS #{access_key}:#{signature}"
          
          # Make the request
          url = "http://#{client.bucket}.s3.amazonaws.com/#{path}"
          request(verb, url, headers, body)
        end
      end

      def request(verb, url, headers={}, body=nil)
        raise "Abstract method"
      end

    end
    
  end  
end
