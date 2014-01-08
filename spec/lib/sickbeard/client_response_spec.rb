require 'spec_helper'

describe SickBeard::ClientResponse do
  let(:failure) do
    '{"data":{},"message":"Show not found","result":"failure"}'
  end
  let(:success) do
    '{"data":{"air_by_date":0,"airs":"Thursday 8:00 PM","cache":{"banner":1,"poster":1},"flatten_folders":0,"genre":["Comedy"],"language":"en","location":"/pond/recorded-tv/The Big Bang Theory","network":"CBS","next_ep_airdate":"2014-01-09","paused":0,"quality":"HD720p","quality_details":{"archive":[],"initial":["hdtv","hdwebdl","hdbluray"]},"season_list":[7,6,5,4,3,2,1,0],"show_name":"The Big Bang Theory","status":"Continuing","tvrage_id":8511,"tvrage_name":"The Big Bang Theory"},"message":"","result":"success"}'
  end
  let(:bad_json) do
    '{"data\':{"bad bad"}'
  end

  context 'good API request' do
    subject { SickBeard::ClientResponse.new(success) }
    its(:success?) { should be_true }
    its(:error?) { should be_false }
    its(:message) { should be_empty }
    its(:data) { should be_a Hash }
  end

  context 'bad API request' do
    subject { SickBeard::ClientResponse.new(failure) }
    its(:success?) { should be_false }
    its(:error?) { should be_true }
    its(:message) { should eq 'Show not found' }
    its(:data) { should be_nil }
  end

  context 'bad constructor' do
    it { expect { SickBeard::ClientResponse.new(1) }.to raise_error(::ArgumentError) }
  end

  context 'bad JSON' do
    let(:malformed_response) { SickBeard::ClientResponse.new(bad_json) }
    it { expect { malformed_response }.to_not raise_error }
    subject { malformed_response }
    its(:success?) { should be_false }
    its(:error?) { should be_true }
    its(:message) { should eq 'Malformed JSON response' }
    its(:data) { should be_nil }
  end
end
