module UberS3::Operation::Object
  module CacheControl
    
    def self.included(base)
      base.send :extend,  ClassMethods
      base.send :include, InstanceMethods
      
      base.instance_eval do
        attr_accessor :cache_control
      end
    end

    module ClassMethods
    end
    
    module InstanceMethods
    end
    
  end
end