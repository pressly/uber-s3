require 'cgi'
require 'time'
require 'openssl'
require 'forwardable'
require 'base64'
require 'digest/md5'
require 'zlib'
require 'stringio'
require 'mime/types'

class UberS3
  extend Forwardable
  
  attr_accessor :connection, :bucket  
  def_delegators :@bucket, :store, :set, :object, :get, :[], :exists?, :objects
  
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
require 'uber-s3/exceptions'
require 'uber-s3/connection'
require 'uber-s3/authorization'
require 'uber-s3/operation'
require 'uber-s3/bucket'
require 'uber-s3/object'

require 'uber-s3/util/xml_document'
