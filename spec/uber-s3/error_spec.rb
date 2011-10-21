require 'spec_helper'

describe UberS3::Error do
  context 'Black hole' do
    
    it 'errors happen' do
      
      expect { raise UberS3::Error::InvalidAccessKeyId }.to raise_error

    end
    
  end
end
