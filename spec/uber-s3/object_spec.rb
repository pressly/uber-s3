require 'spec_helper'

describe UberS3::Object do
  # [:net_http, :em_http_fibered].each do |connection_adapter|
  [:net_http].each do |connection_adapter|

    context "#{connection_adapter}: Object" do
      let(:s3) do
        UberS3.new({
          :access_key         => SETTINGS['access_key'],
          :secret_access_key  => SETTINGS['secret_access_key'],
          :bucket             => SETTINGS['bucket'],
          :adapter            => connection_adapter
        })
      end

      let(:obj) { UberS3::Object.new(s3.bucket, '/test.txt', 'heyo') }
      
      it 'storing and loading an object' do
        spec(s3) do
          obj.save.should == true
          obj.exists?.should == true
      
          #--
      
          key = 'test.txt'
          value = 'testing 1234...'
          
          s3.store(key, value).should == true
      
          s3.exists?(key).should == true
          s3.object(key).exists?.should == true
          s3.exists?('asdfasdfasdf').should == false
      
          s3[key].value.should == value
      
          s3[key].delete.should == true
          s3[key].exists?.should == false
        end
      end
      
      it 'storing an object with SSE' do
        spec(s3) do
          sse_obj = UberS3::Object.new(s3.bucket, '/sse_test.txt', 'heyo', :sse => 'AES256')
          
          sse_obj.save.should == true
          sse_obj.exists?.should == true
          
          sse_obj.delete.should == true
          sse_obj.exists?.should == false          
          
          obj.sse = 'AES256'
          
          obj.save.should == true
          obj.exists?.should == true
          
          obj.delete.should == true
          obj.exists?.should == true
        end
      end
      
      it 'has access level control' do
        spec(s3) do
          obj.access = :public_read
          obj.save.should == true
        end
      end
      
      it 'perform md5 integrity check' do
        spec(s3) do
          obj.content_md5 = Digest::MD5.hexdigest(obj.value)          
          obj.save.should == true
        end
      end

      it 'encode the data with gzip' do
        spec(s3) do        
          key = 'gzip_test.txt'
          value = 'testing 1234...'*256
        
          s3.store(key, value, { :gzip => true })
        
          # Uber S3 client will auto-decode ...
          gzipped_data = s3[key].value
          gzipped_data.bytesize.should == value.bytesize
          
          # But, let's make sure on the server it's the small size
          header = s3.connection.head(key).header
          content_length = [header['content-length']].flatten.first.to_i
          content_length.should < value.bytesize
        end
      end

      it 'keep persistent connection with many objects saved' do
        # NOTE: currently this doesn't actually confirm we've kept
        # a persistent connection open.. just helps with empirical testing
        spec(s3) do
          dummy_data = "A"*1024

          5.times do
            rand_key = (0...8).map{65.+(rand(25)).chr}.join
            s3.store(rand_key, dummy_data)
            # puts "Storing #{rand_key}"
          end

        end
      end

      it 'make head request to get the content length' do
        spec(s3) do
          key = "test.txt"
          value = "testtttttttttting"
          s3.store(key, value)

          obj = s3.object(key).head
          [obj.response.header['content-length']].flatten.first.to_i.should == value.length
        end
      end

      it 'store and load metadata' do
        spec(s3) do
          key = "test.txt"
          value = "yep"
          meta = { 'content_md5' => 'abc' }
          s3.store(key, value, :meta => meta)

          obj = s3.get(key)
          obj.meta['content_md5'].should == meta['content_md5']

          obj = s3.object(key).head
          obj.meta['content_md5'].should == meta['content_md5']
        end
      end
      
    end
    
  end
end
