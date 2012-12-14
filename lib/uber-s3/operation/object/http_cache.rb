module UberS3::Operation::Object
  module HttpCache
    
    def self.included(base)
      # TODO: .. strange behaviour.. can't override these methods in below modules.
      # requires some metaprogramming debugging
      # base.instance_eval do
      #   attr_accessor :cache_control, :expires, :pragma, :ttl
      # end
      
      base.send :extend,  ClassMethods
      base.send :include, InstanceMethods   
    end

    module ClassMethods
    end
    
    module InstanceMethods
      
      # TODO: shouldn't need this junk... see above comment
      def cache_control=(x);    @cache_control = x;         end
      def cache_control;        @cache_control;             end
      
      def expires=(x);          @expires = x;               end
      def expires;              @expires;                   end
      
      def pragma=(x);           @pragma = x;                end
      def pragma;               @pragma;                    end
      
      def ttl=(x);              @ttl = x;                   end
      def ttl;                  @ttl;                       end
      
      #----
      
      # Helper method that will set the max-age for cache-control
      def ttl=(val)
        (@ttl = val).tap { infer_cache_control! }
      end
      
      # TODO... there are some edge cases here.. ie. someone sets their own self.content_type ...
      def infer_cache_control!
        return if ttl.nil? || content_type.nil?
        
        if ttl.is_a?(Hash)
          mime_types = ttl.keys
          match = mime_types.find {|pattern| !(content_type =~ /#{pattern}/i).nil? }
          self.cache_control = "public,max-age=#{ttl[match]}" if match
        else
          self.cache_control = "public,max-age=#{ttl}"
        end
      end

      
      # Expires can take a time or string
      def expires=(val)
        if val.is_a?(String)
          @expires = val
        elsif val.is_a?(Time)
          # RFC 1123 format
          @expires = val.strftime("%a, %d %b %Y %H:%I:%S %Z")
        end
      end
      
    end
        
  end
end
