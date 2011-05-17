# Uber-S3

A simple, but very fast, S3 client written in Ruby supporting
synchronous and asynchronous HTTP communication.

## Examples

```ruby
require 'uber-s3'

# Connection to S3
# adapter can be :net_http or :em_http_sync
client = UberS3.new({
  :access_key         => 'abc',
  :secret_access_key  => 'def',
  :bucket             => 'funbucket',
  :persistent         => true,
  :adapter            => :em_http_sync
})


# Saving objects
client.store('/test.txt', 'Look ma no hands')

o = client.object('/test.txt')
o.value = 'Look ma no hands'
o.save

o = UberS3::Object.new(client.bucket, '/test.txt', 'heyo')
o.save


# Reading objects
s3['/test.txt'].class       # => UberS3::Object
s3['/test.txt'].value       # => 'heyo'
s3.get('/test.txt').value   # => 'heyo'

s3.exists?('/anotherone') # => false


# Deleting objects
o.delete # => true
```

## TODO

* ACL
* Support for iterating objects in a bucket
* lots... still very early

## S3 API Docs

- S3 REST API: http://docs.amazonwebservices.com/AmazonS3/latest/API/
- S3 Request Authorization: http://docs.amazonwebservices.com/AmazonS3/latest/dev/RESTAuthentication.html
