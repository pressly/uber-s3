# Uber-S3

A simple, but very fast, S3 client written in Ruby supporting
synchronous and asynchronous HTTP communication.

## Examples

```ruby
require 'uber-s3'

##########################################################################
# Connecting to S3
# adapter can be :net_http or :em_http_fibered
s3 = UberS3.new({
  :access_key         => 'abc',
  :secret_access_key  => 'def',
  :bucket             => 'funbucket',
  :persistent         => true,
  :adapter            => :em_http_fibered
})



##########################################################################
# Saving objects
s3.store('/test.txt', 'Look ma no hands')

o = s3.object('/test.txt')
o.value = 'Look ma no hands'
o.save

# or..

o = UberS3::Object.new(client.bucket, '/test.txt', 'heyo')
o.save # => true



##########################################################################
# Reading objects
s3['/test.txt'].class       # => UberS3::Object
s3['/test.txt'].value       # => 'heyo'
s3.get('/test.txt').value   # => 'heyo'

s3.exists?('/anotherone')   # => false



##########################################################################
# Object access control

o.access = :private
o.access = :public_read
# etc.

# Valid options:
# :private, :public_read, :public_read_write, :authenticated_read

# See http://docs.amazonwebservices.com/AmazonS3/2006-03-01/dev/index.html?RESTAccessPolicy.html
# NOTE: default object access level is :private



##########################################################################
# Deleting objects
o.delete # => true


##########################################################################
# Save optional parameters
# See http://docs.amazonwebservices.com/AmazonS3/latest/API/index.html?RESTObjectPUT.html

options = { :access => :public_read, :content_type => 'text/plain' }
o = UberS3::Object.new(client.bucket, '/test.txt', 'heyo', options)
o.save

# or..

o = s3.object('/test.txt')
o.value = 'Look ma no hands'
o.access = :public_read
o.content_type = 'text/plain'
o.save

# List of parameter methods:
# :access               -- Object access control
# :cache_control        -- http://www.w3.org/Protocols/rfc2616/rfc2616-sec14.html#sec14.9
# :content_disposition  -- http://www.w3.org/Protocols/rfc2616/rfc2616-sec19.html#sec19.5.1
# :content_encoding     -- http://www.w3.org/Protocols/rfc2616/rfc2616-sec14.html#sec14.11
# :content_md5          -- End-to-end integrity check
# :content_type         -- http://www.w3.org/Protocols/rfc2616/rfc2616-sec14.html#sec14.17
# :expires              -- Number of milliseconds before expiration
# :storage_class        -- Amazon S3's storage levels (redundancy for price)


##########################################################################
# Iterating objects in a bucket
s3.objects('/path').each {|obj| puts obj } 

```

## Other tips

* If Nokogiri is available, it will use it instead of REXML

## TODO

* Object URL construction
* Refactor UberS3::Object class, consider putting the operations/headers into separate classes
* Better exception handling and reporting
* Query string authentication -- neat feature for providing temporary public access to a private object
* Object versioning support

## S3 API Docs

- S3 REST API: http://docs.amazonwebservices.com/AmazonS3/latest/API/
- S3 Request Authorization: http://docs.amazonwebservices.com/AmazonS3/latest/dev/RESTAuthentication.html
