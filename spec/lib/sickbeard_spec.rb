require 'spec_helper'

describe SickBeard do
  context 'set connection parameters' do
    let(:string) { 'http://gogole.com:9091' }
    let(:key) do
      # http://stackoverflow.com/questions/88311/how-best-to-generate-a-random-string-in-ruby
      o = [('a'..'z'), ('A'..'Z')].map { |i| i.to_a }.flatten
      string = (0...50).map { o[rand(o.length)] }.join
      Digest::MD5.hexdigest(string)
    end
    let(:uri) { URI.parse(string) }
    let(:client) { SickBeard::Client.new('gogole.com', key, 'http', 9091) }

    describe 'setting client' do
      context 'from string' do
        before(:each) do
          SickBeard.key = key
          SickBeard.client = string
        end

        its(:client) { should be_an_instance_of(SickBeard::Client) }
        it { SickBeard.client.to_s.should eq "#{string}/api/#{key}" }
      end

      context 'from URI' do
        before(:each) do
          SickBeard.key = key
          SickBeard.client = uri
        end

        its(:client) { should be_an_instance_of(SickBeard::Client) }
        it { SickBeard.client.to_s.should eq "#{string}/api/#{key}" }
      end
      context 'from Client' do
        before(:each) do
          SickBeard.key = key
          SickBeard.client = client
        end

        its(:client) { should be_an_instance_of(SickBeard::Client) }
        it { SickBeard.client.to_s.should eq "#{string}/api/#{key}" }
      end
    end
  end
end
