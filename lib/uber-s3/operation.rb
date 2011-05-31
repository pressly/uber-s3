class UberS3
  module Operation
    
    # Load and include all operations
    Dir[File.dirname(__FILE__)+'/operation/*'].each do |group|
      Dir[group+'/*.rb'].each do |op|
      
        group_klass_name = File.basename(group).split('_').map {|x| x.capitalize}.join("")
        op_klass_name    = File.basename(op).gsub(/.rb$/i, '').split('_').map {|x| x.capitalize}.join("")
        
        require op
        op_klass = instance_eval(group_klass_name+'::'+op_klass_name)
        group_klass = instance_eval(group_klass_name)
      
        group_klass.send :include, op_klass
      end
    end
        
  end
end


