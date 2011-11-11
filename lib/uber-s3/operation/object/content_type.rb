module UberS3::Operation::Object
  module ContentType
    
    def self.included(base)
      base.send :extend,  ClassMethods
      base.send :include, InstanceMethods
      
      base.instance_eval do
        # attr_accessor :content_type
      end
    end

    module ClassMethods
    end
    
    module InstanceMethods
      
      def infer_content_type!
        mime_type = MIME::Types.type_for(key).first

        self.content_type ||= mime_type.content_type if mime_type
        self.content_type ||= 'binary/octet-stream'
      end
      
      def content_type=(x);     @content_type = x;          end
      def content_type;         @content_type;              end
      
    end
    
  end
end