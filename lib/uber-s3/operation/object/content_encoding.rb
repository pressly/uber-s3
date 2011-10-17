module UberS3::Operation::Object
  module ContentEncoding
    
    def self.included(base)
      base.send :extend,  ClassMethods
      base.send :include, InstanceMethods
      
      base.instance_eval do
        attr_accessor :gzip, :content_encoding
      end
    end

    module ClassMethods
    end
    
    module InstanceMethods
      
      # Default mime-types to be auto-gzipped if gzip == :web
      WEB_GZIP_TYPES = ['text/html', 'text/plain', 'text/css',
                        'application/javascript', 'application/x-javascript',
                        'text/xml', 'application/xml', 'application/xml+rss']
      
      private
      
        def gzip_content!
          return if gzip.nil?
          
          if gzip == true
            encode = true
          elsif gzip == :web && WEB_GZIP_TYPES.include?(content_type)
            encode = true
          elsif gzip.is_a?(String) && gzip == content_type
            encode = true
          elsif gzip.is_a?(Array) && gzip.include?(content_type)
            encode = true
          else
            encode = false
          end
          
          if encode
            self.value = gzip_encoder(value)
            self.content_encoding = 'gzip'
          end
        end
      
        def gzip_encoder(data)
          begin
            gz_stream = StringIO.new
            gz = Zlib::GzipWriter.new(gz_stream)
            gz.write(value)
            gz.close

            gz_stream.string
          rescue => ex
            # TODO ...
            $stderr.puts "Gzip failed: #{ex.message}"
            raise ex
          end
        end
      
    end
    
  end
end