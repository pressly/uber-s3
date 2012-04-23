class UberS3
  class Bucket
    attr_accessor :s3, :name
    
    def initialize(s3, name)
      self.s3   = s3
      self.name = name
    end

    def to_s
      name.to_s
    end
    
    def connection
      s3.connection
    end

    def store(key, value, options={})
      Object.new(self, key, value, options).save
    end
    alias_method :set, :store

    def object(key)
      Object.new(self, key)
    end
    alias_method :[], :object

    def get(key)
      object(key).fetch
    end

    def head(key)
      object(key).head
    end

    def exists?(key)
      object(key).exists?
    end
    
    def objects(key, options={})
      ObjectList.new(self, key, options)
    end
    
    
    class ObjectList
      include Enumerable
      
      attr_accessor :bucket, :key, :options, :objects
      
      def initialize(bucket, key, options={})
        self.bucket   = bucket
        self.key      = key.gsub(/^\//, '')
        self.options  = options
        self.objects  = []
      end
      
      def fetch(marker=nil)
        @objects = []

        default_max_keys = 500
        response = bucket.connection.get("/?prefix=#{CGI.escape(key)}&marker=#{marker}&max-keys=#{default_max_keys}")        

        @objects = parse_contents(response.body)
      end
      
      def parse_contents(xml)
        objects = []
        doc = Util::XmlDocument.new(xml)
        
        # TODO: can use more error checking on the xml stuff
        
        @is_truncated = doc.xpath('//ListBucketResult/IsTruncated').first.text == "true"
        contents = doc.xpath('//ListBucketResult/Contents')
        
        contents.each do |content|
          h = {}
          content.elements.each {|el| h[el.name] = el.text }
          objects << ::UberS3::Object.new(bucket, h['Key'], nil, { :size => h['Size'].to_i })
        end if contents.any?

        objects
      end
      
      def each(&block)
        loop do
          marker = objects.last.key rescue nil
          fetch(marker)
          
          objects.each {|obj| block.call(obj) }
          break if @is_truncated == false
        end
      end
      
      def to_a
        fetch
      end
    end
    
  end
end
