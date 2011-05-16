class UberS3
  class Object
    attr_accessor :bucket, :key, :value
    
    def initialize(bucket, key, value=nil, options={})
      self.bucket = bucket
      self.key    = key
      self.value  = value
      # TODO: options... acl, etc...
    end
    
    def exists?
      bucket.connection.head(key)[:status] == 200
    end
    
    def fetch
      @value = bucket.connection.get(key)[:body]
      self
    end
    
    def save
      response = bucket.connection.put(key, {}, value) # TODO: options...
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
    end
    
    def url
    end
    
    def key=(key)
      @key = "/#{key}".gsub('//', '/') # TODO: better way of doing this?
    end
    
  end
end
