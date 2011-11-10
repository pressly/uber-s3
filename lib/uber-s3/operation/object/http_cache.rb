module UberS3::Operation::Object
  module HttpCache
    
    def self.included(base)
      base.send :extend,  ClassMethods
      base.send :include, InstanceMethods
      
      base.instance_eval do
        attr_accessor :cache_control, :expires, :pragma, :ttl
      end
    end

    module ClassMethods
    end
    
    module InstanceMethods
      
      # Helper method that will set the max-age for cache-control
      def ttl=(seconds)
        @ttl = seconds
        self.cache_control = "public,max-age=#{seconds}"
      end
      
      # Expires can take a time or string
      def expires=(val)
        if val.is_a?(String)
          self.expires = val
        elsif val.is_a?(Time)
          # RFC 1123 format 
          self.expires = val.strftime("%a, %d %b %Y %H:%I:%S %Z")
        end
      end
      
    end
        
  end
end
