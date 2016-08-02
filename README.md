# Uber-S3

A simple, but very fast, S3 client for Ruby supporting
synchronous (net-http) and asynchronous (em+fibers) io.


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
  :adapter            => :em_http_fibered
})

# Custom host, with bucket in path instead of as a subdomain
s3 = UberS3.new({
  :access_key         => 'abc',
  :secret_access_key  => 'def',
  :bucket             => 'funbucket',
  :adapter            => :em_http_fibered,
  :host               => 'localhost:4567',
  :path_style         => true
})



##########################################################################
# Saving objects
s3.store('/test.txt', 'Look ma no hands')
s3.store('test2.txt', 'Hey hey', :access => :public_read)

o = s3.object('/test.txt')
o.value = 'Look ma no hands'
o.save

# or..

o = UberS3::Object.new(s3.bucket, '/test.txt', 'heyo')
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

* Tested on MRI 1.9.2, MRI 1.9.3 (net_http / em_http_fibered adapters)
* Tested on JRuby 1.7-dev in 1.9 mode (net_http)
* Ruby 1.8.7 works for net/http clients, em_http_fibered adapter requires fibers

## Other notes

* If Nokogiri is available, it will be automatically used instead of REXML

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

MIT License - Copyright (c) 2012 Nulayer Inc.
