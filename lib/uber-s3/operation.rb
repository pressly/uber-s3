class UberS3
  module Operation
  end
end

# Load object operation modules
Dir[File.dirname(__FILE__) + '/operation/object/*.rb'].each {|f| require f }
