class UberS3
  class Object

    attr_accessor :bucket, :key, :value, :errors
    # attr_accessor :etag, :last_modified
    
    attr_accessor :access,
                  :cache_control,
                  :content_disposition,
                  :content_encoding,
                  :size,
                  :content_md5,
                  :content_type,
                  :expires,
                  :storage_class
    
    def initialize(bucket, key, value=nil, options={})
      self.bucket = bucket
      self.key    = key
      self.value  = value
      
      options.each {|k,v| self.send((k.to_s+'=').to_sym, v) }
    end
    
    def to_s
      "#<#{self.class} @key=\"#{self.key}\">"
    end
    
    def exists?
      bucket.connection.head(key)[:status] == 200
    end
    
    def fetch
      self.value = bucket.connection.get(key)[:body]
      self
    end
    
    def save
      headers = {}
      
      # Standard pass through values
      headers['Cache-Control']        = cache_control
      headers['Content-Disposition']  = content_disposition
      headers['Content-Encoding']     = content_encoding
      headers['Content-Length']       = size.to_s
      headers['Content-MD5']          = content_md5
      headers['Content-Type']         = content_type
      headers['Expires']              = expires
            
      headers.each {|k,v| headers.delete(k) if v.nil? || v.empty? }

      # Content MD5 integrity check
      if !content_md5.nil?
        # Our object expects a md5 hex digest
        md5_digest = content_md5.unpack('a2'*16).collect {|i| i.hex.chr }.join
        headers['Content-MD5'] = Base64.encode64(md5_digest).strip
      end

      # ACL
      if !access.nil?
        headers['x-amz-acl'] = access.to_s.gsub('_', '-')
      end
      
      # Storage class
      if !storage_class.nil?
        headers['x-amz-storage-class'] = storage_class.to_s.upcase
      end
      
      # Let's do it
      response = bucket.connection.put(key, headers, value)
      
      if response[:status] != 200
        self.errors = response[:body]    
      else
        self.errors = nil
      end
      
      response[:status] == 200
    end
    
    def delete
      bucket.connection.delete(key)[:status] == 204
    end
    
    def value
      fetch if !@value
      @value
    end
    
    def persisted?
      # TODO
    end
    
    def url
      # TODO
    end
    
    def key=(key)
      @key = key.gsub(/^\//,'')
    end
    
    ##########################
    
    def value=(value)
      self.size = value.to_s.bytesize
      @value = value
    end
    
    def access=(access)
      valid_values = [:private, :public_read, :public_read_write, :authenticated_read]
      
      if valid_values.include?(access)
        @access = access
      else
        raise "Invalid access value"
      end
    end
    
    def storage_class=(storage_class)
      valid_values = [:standard, :reduced_redundancy]
      
      if valid_values.include?(storage_class)
        @storage_class = storage_class
      else
        raise "Invalid storage_class value"
      end
    end
    
  end
end
