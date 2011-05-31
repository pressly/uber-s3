begin
  require 'nokogiri'
rescue LoadError
  require 'rexml/document'
end

module UberS3::Util
  class XmlDocument
    
    def initialize(xml)
      if defined?(Nokogiri)
        @parser = NokogiriParser.new(xml)
      else
        @parser = RexmlParser.new(xml)
      end
    end
    
    def method_missing(sym, *args, &block)
      @parser.send sym, *args, &block
    end
        
    class RexmlParser
      attr_accessor :doc
      
      def initialize(xml)
        self.doc = REXML::Document.new(xml)
      end
      
      def xpath(path)
        REXML::XPath.match(doc.root, path)
      end
    end
    
    class NokogiriParser
      attr_accessor :doc
      
      def initialize(xml)
        self.doc = Nokogiri::XML(xml)
      end
      
      def xpath(path)
        doc.xpath(path)
      end
    end
    
  end
end
