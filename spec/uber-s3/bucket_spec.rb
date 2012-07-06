require 'spec_helper'

describe UberS3::Bucket do
  # [:net_http, :em_http_fibered].each do |connection_adapter|
  [:net_http].each do |connection_adapter|

    
    context "#{connection_adapter}: Bucket" do
      let(:s3) do
        UberS3.new({
          :access_key         => SETTINGS['access_key'],
          :secret_access_key  => SETTINGS['secret_access_key'],
          :bucket             => SETTINGS['bucket'],
          :adapter            => connection_adapter
        })
      end

      it 'iterates objects in a bucket' do
        spec(s3) do
          folder = 'bucket_spec'
          
          s3.store(folder+'/file1.txt', '1')
          s3.store(folder+'/file2.txt', '2')
          s3.store(folder+'/file3.txt', '3')
          
          objs = []
          s3.objects('/bucket_spec').each do |obj|
            objs << obj
          end
          
          objs.length.should == 3
        end
      end

    end
    
  end
end
