module UberS3::Operation::Object
  module Meta
    
    def self.included(base)
      base.send :extend,  ClassMethods
      base.send :include, InstanceMethods
      
      base.instance_eval do
        attr_writer :meta
      end
    end

    module ClassMethods
    end
    
    module InstanceMethods
      def meta
        fetch unless @meta
        @meta
      end
      
      def set_meta(key, value)
        @meta ||= {}
        @meta[key] = value
      end 
    end
    
  end
end