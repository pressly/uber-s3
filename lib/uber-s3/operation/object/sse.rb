module UberS3::Operation::Object
  module SSE
    
    def self.included(base)
      base.send :extend,  ClassMethods
      base.send :include, InstanceMethods
      
      base.instance_eval do
        attr_accessor :sse
      end
    end

    module ClassMethods
    end
    
    module InstanceMethods
      def sse=(sse)
        valid_values = ['AES256']

        if valid_values.include?(sse)
          @sse = sse
        else
          raise "Invalid sse value"
        end
      end
    end
    
  end
end