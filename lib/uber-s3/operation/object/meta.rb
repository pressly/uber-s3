module UberS3::Operation::Object
  module Meta
    
    def self.included(base)
      base.send :extend,  ClassMethods
      base.send :include, InstanceMethods
      
      base.instance_eval do
      end
    end

    module ClassMethods
    end
    
    module InstanceMethods
    end
    
  end
end