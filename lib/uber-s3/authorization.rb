class UberS3
  module Authorization
    
    def sign(client, verb, path, headers={})
      req_verb                  = verb.to_s.upcase
      req_content_md5           = headers['Content-MD5']
      req_content_type          = headers['Content-Type']
      req_date                  = headers['Date']
      req_canonical_resource    = "/#{client.bucket}/#{path}".split('?').first
      req_canonical_amz_headers = ''

      headers.keys.select {|k| k =~ /^x-amz-acl/ }.each do |amz_key|
        req_canonical_amz_headers << amz_key+':'+headers[amz_key]+"\n"
      end
      
      canonical_string_to_sign = "#{req_verb}\n"+
                                 "#{req_content_md5}\n"+
                                 "#{req_content_type}\n"+
                                 "#{req_date}\n"+
                                 "#{req_canonical_amz_headers}"+
                                 "#{req_canonical_resource}"
      
      digest = OpenSSL::Digest::Digest.new('sha1')
      [OpenSSL::HMAC.digest(digest, client.connection.secret_access_key, canonical_string_to_sign)].pack("m").strip
    end
    
    extend self    
  end
end
