class UberS3
  module Operation
    
    module Bucket
      module All
        def self.included(base)
          Operation.include_modules(base, 'bucket')
        end
      end
    end
    
    module Object
      module All
        def self.included(base)
          Operation.include_modules(base, 'object')
        end
      end
    end
    
    def include_modules(base, path)
      # Auto include modules of a particular path
      Dir[File.dirname(__FILE__)+"/operation/#{path}/*.rb"].each do |op|
        group_module_name = self.to_s + '::' + path.split('_').map {|x| x.capitalize}.join("")
        op_klass_name = File.basename(op).gsub(/.rb$/i, '').split('_').map {|x| x.capitalize}.join("")
          
        require op
        op_klass = instance_eval(group_module_name+'::'+op_klass_name)
        
        base.send :include, op_klass
      end
    end
    module_function :include_modules
        
  end
end
