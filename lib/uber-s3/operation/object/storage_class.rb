module UberS3::Operation::Object
  module StorageClass
    
    def self.included(base)
      base.send :extend,  ClassMethods
      base.send :include, InstanceMethods
      
      base.instance_eval do
        attr_accessor :storage_class
      end
    end

    module ClassMethods
    end
    
    module InstanceMethods
      def storage_class=(storage_class)
        valid_values = [:standard, :reduced_redundancy]

        if valid_values.include?(storage_class)
          @storage_class = storage_class
        else
          raise "Invalid storage_class value"
        end
      end
    end
    
  end
end