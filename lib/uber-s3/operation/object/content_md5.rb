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
      # TODO.. move stuff from object.rb to here... need callback / chaining stuff...
    end
    
  end
end