module UberS3::Operation::Object
  module ContentMd5
    
    def self.included(base)
      base.send :extend,  ClassMethods
      base.send :include, InstanceMethods
      
      base.instance_eval do
        attr_accessor :content_md5
      end
    end

    module ClassMethods
    end
    
    module InstanceMethods
    end
    
  end
end