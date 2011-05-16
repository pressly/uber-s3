class UberS3
  class Bucket    
    attr_accessor :client, :name
    
    def initialize(client, name)
      self.client = client
      self.name   = name
    end

    def to_s
      name.to_s
    end
    
    def connection
      client.connection
    end

    def store(key, value, options={})
      Object.new(self, key, value, options).save
    end
    alias_method :set, :store

    def object(key)
      Object.new(self, key)
    end

    def get(key)
      object(key).fetch
    end
    alias_method :[], :get

    def exists?(key)
      object(key).exists?
    end


    def index
    end
    
    def objects(options={})
    end
    
    
  end
end
