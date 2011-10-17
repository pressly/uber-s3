module UberS3::Operation::Object
  module Expires
    
    def self.included(base)
      base.send :extend,  ClassMethods
      base.send :include, InstanceMethods
      
      base.instance_eval do
        attr_accessor :expires
      end
    end

    module ClassMethods
    end
    
    module InstanceMethods
    end
    
  end
end