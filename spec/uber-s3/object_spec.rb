require 'eventmachine'
require 'em-http'
require 'em-synchrony'
require 'em-synchrony/em-http'

require 'spec_helper'

describe UberS3::Object do
    
  context 'Object' do
    let(:s3) do
      {}.tap do |clients|
        [:net_http, :em_http_sync].each do |mode|
          clients[mode] = UberS3.new({
            :access_key         => SETTINGS['access_key'],
            :secret_access_key  => SETTINGS['secret_access_key'],
            :bucket             => SETTINGS['bucket'],
            :persistent         => SETTINGS['persistent'],
            :adapter            => mode
          })
        end
      end
    end
        
    it 'storing and loading an object' do
      spec = Proc.new do |client|
        key = 'test.txt'
        value = 'testing 1234...'
      
        client.store(key, value).should == true
      
        client.exists?(key).should == true
        client.object(key).exists?.should == true
        client.exists?('asdfasdfasdf').should == false
      
        client[key].value.should == value
      
        client[key].delete.should == true
        client[key].exists?.should == false
      end
      
      spec.call(s3[:net_http])
      
      EM.synchrony do
        spec.call(s3[:em_http_sync])
        EM.stop
      end
    end
    
    # let(:client) do
    #   UberS3.new({
    #     :access_key         => SETTINGS['access_key'],
    #     :secret_access_key  => SETTINGS['secret_access_key'],
    #     :bucket             => SETTINGS['bucket'],
    #     :persistent         => SETTINGS['persistent'],
    #     :adapter            => :em_http
    #   })
    # end
    #     
    # it 'storing and loading an object' do
    #   EM.run do
    #     key = 'test.txt'
    #     value = 'testing 1234...'
    #   
    #     stop = Proc.new {|msg| $stderr.puts msg; EM.stop }
    #   
    #   
    #     req = client.store(key, value)
    #     
    #     req.callback {
    #       
    #     }
    #     req.errback { stop() }
    #   
    #     client.exists?(key).should == true
    #     client.object(key).exists?.should == true
    #     client.exists?('asdfasdfasdf').should == false
    #   
    #     client[key].value.should == value
    #   
    #     client[key].delete.should == true
    #     client[key].exists?.should == false
    #     
    #     
    #   end
    # 
    # end
    
  end
  
end

__END__

# Write
s3.store('/blah/test.txt', 'data goes here ...', :access => :public_read, :etc => 'value')
# alias store to: set, write

s3.store(object)

# Read
puts s3['/hi.jpg']
puts s3.read('/hi.jpg')
puts s3.get('/hi.jpg')

puts s3.object('/hi.jpg').load


# Get objects
s3.objects('/blah', :num => 20).each {|x| puts x } # iterates 20 objects at a time..

# Object stuff .. ex. of modifying an object
x = s3['/hi.jpg']
x.value = 'data goes here'
x.acl = { ... etc ... }
x.public_read = true
x.save

x.delete

y = UberS3::Object.new(s3_client, filename)
# or
y = s3.object(filename)

y.value = "..."
y.save

#--------- ideas:

- Add defaults to S3 connection for ACL stuff.. ie. all public_read or something else..
