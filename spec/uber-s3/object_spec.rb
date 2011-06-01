require 'spec_helper'

describe UberS3::Object do
  [:net_http, :em_http_fibered].each do |connection_adapter|
    
    context "#{connection_adapter}: Object" do
      let(:s3) do
        UberS3.new({
          :access_key         => SETTINGS['access_key'],
          :secret_access_key  => SETTINGS['secret_access_key'],
          :bucket             => SETTINGS['bucket'],
          :persistent         => SETTINGS['persistent'],
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

    end
    
  end
end
