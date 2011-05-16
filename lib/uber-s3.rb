require 'time'
require 'openssl'
require 'forwardable'

class UberS3
  extend Forwardable
  
  # TODO: should go somewhere else.. prob Connection
  # AMAZON_HEADER_PREFIX = 'x-amz-'
  
  attr_accessor :connection, :bucket
  
  def_delegators :@bucket, :store, :set, :object, :get, :[], :exists?
  
  
  def initialize(options={})
    self.connection = Connection.open(self, options)
    self.bucket     = options[:bucket]
  end
  
  def inspect
    "#<UberS3 client v#{UberS3::VERSION}>"
  end
  
  def bucket=(bucket)
    @bucket = bucket.is_a?(Bucket) ? bucket : Bucket.new(self, bucket)
  end
    
end

require 'uber-s3/version'
require 'uber-s3/connection'
require 'uber-s3/authorization'
require 'uber-s3/bucket'
require 'uber-s3/object'
