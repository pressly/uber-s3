class UberS3
  
  module Error
  
    class Standard < StandardError
      def initialize
        super("............ pffffffffft")
      end
    end
  
    class InvalidAccessKeyId    < Standard; end
    class SignatureDoesNotMatch < Standard; end

  end
  
  
  
# ... do we put this in a response object......? does make sense actually...
# .........................

  
# List of Amazon errors .........

# Two types
# 1. Communication .. standard HTTP stuff here.
# 2. Amazon API specific issues.. auth, access, etc. etc. etc.........

=begin

=> "<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n<Error><Code>InvalidAccessKeyId</Code>

=> "<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n<Error><Code>SignatureDoesNotMatch</Code>



=end
  
  
  
  
end
