require 'bundler'
Bundler.setup

require 'eventmachine'
require 'em-http-request'
require 'openssl'
require 'time'

require 'ruby-debug'

EM.run do
  
  access_key = 'x'
  secret_access_key = 'y'
  bucket = 'nutestbucket'

  request_path = "/test2.txt"
  
  #------------------
  
  # Building the request packet
  req_method = 'GET'
  req_content_md5 = ''
  req_content_type = ''
  req_date = Time.now.httpdate
  req_canonical_amz_headers = ''
  req_canonical_resource = "/#{bucket}#{request_path}"
  
  canonical_string_to_sign = "#{req_method}\n#{req_content_md5}\n#{req_content_type}\n#{req_date}\n#{req_canonical_amz_headers}#{req_canonical_resource}"
  
  digest   = OpenSSL::Digest::Digest.new('sha1')
  signature = [OpenSSL::HMAC.digest(digest, secret_access_key, canonical_string_to_sign)].pack("m").strip
  
  #-----------
  
  headers = {
    'Authorization' => "AWS #{access_key}:#{signature}",
    'Date' => req_date
  }
  
  http = EM::HttpRequest.new("http://#{bucket}.s3.amazonaws.com#{request_path}").get :head => headers
  
  http.callback do |x|
    puts x.inspect
  end
  http.errback do |x|
    puts x.inspect
  end
  
end
