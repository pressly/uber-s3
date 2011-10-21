class UberS3
  class Object
    include Operation::Object::AccessPolicy
    include Operation::Object::CacheControl
    include Operation::Object::ContentDisposition
    include Operation::Object::ContentEncoding
    include Operation::Object::ContentMd5
    include Operation::Object::ContentType
    include Operation::Object::Expires
    include Operation::Object::Meta
    include Operation::Object::StorageClass

    attr_accessor :bucket, :key, :value, :size, :error
    
    def initialize(bucket, key, value=nil, options={})
      self.bucket        = bucket
      self.key           = key
      self.value         = value
      
      # Init current state
      infer_content_type!
      
      # Call operation methods based on options passed
      bucket.connection.defaults.merge(options).each {|k,v| self.send((k.to_s+'=').to_sym, v) }
    end
    
    def to_s
      "#<#{self.class} @key=\"#{self.key}\">"
    end
    
    def exists?
      bucket.connection.head(key).status == 200
    end
    
    def fetch
      self.value = bucket.connection.get(key).body
      self
    end
    
    def save
      headers = {}
      
      # Encode data if necessary
      gzip_content!
      
      # Standard pass through values
      headers['Cache-Control']        = cache_control
      headers['Content-Disposition']  = content_disposition
      headers['Content-Encoding']     = content_encoding
      headers['Content-Length']       = size.to_s
      headers['Content-Type']         = content_type
      headers['Expires']              = expires
            
      headers.each {|k,v| headers.delete(k) if v.nil? || v.empty? }

      # Content MD5 integrity check
      if !content_md5.nil?
        self.content_md5 = Digest::MD5.hexdigest(value) if content_md5 == true

        # We expect a md5 hex digest here
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
      
      # Update error state
      self.error = response.error
      
      # Test for success....
      response.status == 200      
    end
    
    def delete
      bucket.connection.delete(key).status == 204
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
    
    def value=(value)
      self.size = value.to_s.bytesize
      @value = value
    end
    
    # TODO..
    # Add callback support so Operations can hook into that ... cleaner. ie. on_save { ... }
    
  end
end
