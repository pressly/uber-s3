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

## Ruby version notes

* Tested on MRI 1.9.2 (net_http / em_http_fibered adapters) -- recommended
* Ruby 1.8.7 works for net/http clients, em_http_fibered adapter requires fibers (duh)
* JRuby in 1.9 mode + em_http_fibered adapter should work, but held back because of issues with EM

## Other notes

* If Nokogiri is available, it will use it instead of REXML

## TODO

* Refactor UberS3::Object class, consider putting the operations/headers into separate classes
* Better exception handling and reporting
* Query string authentication -- neat feature for providing temporary public access to a private object
* Object versioning support

## Benchmarks

Benchmarks were run with a speedy MBP on a 10Mbit connection

### Saving lots of 1KB files

<pre>
                                                        user     system      total        real
saving 100x1024 byte objects (net-http)            0.160000   0.080000   0.240000 ( 26.128499)
saving 100x1024 byte objects (em-http-fibered)     0.080000   0.030000   0.110000 (  0.917334)
</pre>

### Saving lots of 500KB files

<pre>
                                                        user     system      total        real
saving 100x512000 byte objects (net-http)          0.190000   0.740000   0.930000 ( 91.559123)
saving 100x512000 byte objects (em-http-fibered)   0.230000   0.700000   0.930000 ( 45.119033)
</pre>

### Conclusion

Yea... async adapter dominates. The 100x1KB files were 29x faster to upload, and the 100x500KB files were only 2x faster, but that is because my upload bandwidth was tapped.


## S3 API Docs

- S3 REST API: http://docs.amazonwebservices.com/AmazonS3/latest/API/
- S3 Request Authorization: http://docs.amazonwebservices.com/AmazonS3/latest/dev/RESTAuthentication.html


## License

MIT License - Copyright (c) 2011 Nulayer Inc.
