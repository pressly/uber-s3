#!/usr/bin/env ruby
$:<< '../lib' << 'lib'
###############################################################################
# This example demonstrates the combined power of eventmachine+fibers.
# Notice how the example code is exactly the same as basic.rb
# except instead it's using a non-blocking http client.. boom.
#
# Btw, make sure to bundle up first...
###############################################################################

require 'uber-s3'

s3 = UberS3.new({
  :access_key         => 'x',
  :secret_access_key  => 'y',
  :bucket             => 'nutestbucket',
  :adapter            => :em_http_fibered
})

x = Proc.new do
  # Traverse all objects in the bucket -- beware of huge buckets :)
  # This will only load the keys and basic info of the object, not the data
  s3.objects('/').each do |obj|
    puts obj
    # puts obj.value # this will actually fetch the data on demand
  end
end

EM.run do
  Fiber.new {
    x.call
    EM.stop
  }.resume
end
