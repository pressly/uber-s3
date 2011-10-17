module UberS3::Operation::Object
  module AccessPolicy
    
    def self.included(base)
      base.send :extend,  ClassMethods
      base.send :include, InstanceMethods
      
      base.instance_eval do
        attr_accessor :access
      end
    end

    module ClassMethods
    end
    
    module InstanceMethods
      def access=(access)
        valid_values = [:private, :public_read, :public_read_write, :authenticated_read]

        if valid_values.include?(access)
          @access = access
        else
          raise "Invalid access value"
        end
      end
    end
    
  end
end