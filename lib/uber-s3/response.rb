class UberS3  
  class Response
    
    attr_accessor :status, :header, :body, :raw, :error_key, :error_message
    
    def initialize(options={})
      if !([:status, :header, :body, :raw] - options.keys).empty?
        raise "Expecting keys :status, :header, :body and :raw"
      end
      
      self.status = options[:status]
      self.header = options[:header]
      self.body   = options[:body]
      self.raw    = options[:raw]
      
      check_for_errors!
    end
    
    # TODO: can/should we normalize the keys..? downcase.. etc.?
    # def header=(header)
    # end
    
    def check_for_errors!
      return if status < 400 || body.to_s.empty?
      
      # Errors are XML
      doc = Util::XmlDocument.new(body)
      
      self.error_key      = doc.xpath('//Error/Code').first.text
      self.error_message  = doc.xpath('//Error/Message').first.text
      
      error_klass = instance_eval("Error::#{error_key}") rescue nil
      
      if error_klass.nil?
        raise Error::Unknown, "HTTP Response: #{status}, Body: #{body}"
      else
        raise error_klass.new(error_key, error_message)
      end
    end
    
    def error
      if !error_key.nil?
        "#{error_key}: #{error_message}"
      end
    end
    
        
  end
end
