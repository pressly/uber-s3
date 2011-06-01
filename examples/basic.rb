#!/usr/bin/env ruby
$:<< '../lib' << 'lib'
###############################################################################
# This simple example loops through the objects in a bucket
###############################################################################

require 'uber-s3'

s3 = UberS3.new({
  :access_key         => 'AKIAIIG7K3KMY5BPW7TA',
  :secret_access_key  => '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',
  :bucket             => 'nutestbucket',
  :adapter            => :net_http
})

# Traverse all objects in the bucket -- beware :)
# This will only load the keys and basic info of the object, not the data
s3.objects('/').each do |obj|
  puts obj
  # puts obj.value # this will actually fetch the data on demand
end
