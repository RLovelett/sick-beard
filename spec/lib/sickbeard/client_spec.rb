require 'spec_helper'

describe SickBeard::Client, vcr: {
  cassette_name: 'sickbeard_client',
  record: :new_episodes,
  match_requests_on: [:uri]
} do

  context 'set the Sick Beard API URI' do
    let(:cmd) { 'show' }
    let(:tvdbid) { 745689 }
    let(:base_uri) { 'https://lovelett.me/api/12345' }
    let(:client) { SickBeard::Client.new('lovelett.me', 12345, 'https', 443) }
    subject { client }
    describe 'uri' do
      context 'Sick Beard API cmd show and TVDBID of 745689 no options' do
        it { expect(client.uri(cmd, tvdbid).to_s).to eq "#{base_uri}?cmd=#{cmd}&tvdbid=#{tvdbid}" }
      end
      context 'with options' do
        it { expect(client.uri(cmd, tvdbid, {sort: 'name'}).to_s).to eq "#{base_uri}?cmd=#{cmd}&tvdbid=#{tvdbid}&sort=name" }
      end
    end
    its(:to_s) { should eq base_uri }
  end

  context 'no response from the api' do
    before(:each) { stub_request(:any, /toodles.*/).to_timeout }
    let(:client) { SickBeard::Client.new('toodles', 8081) }
    let(:uri) { client.uri('shows', {sort: 'name'}) }
    let(:request) { SickBeard::Client.request(uri) }
    subject { request }
    it { expect{ request }.to_not raise_error }
    it { should be_a(SickBeard::ClientResponse) }
    its(:success?) { should be false }
    its(:error?) { should be_true }
    its(:data) { should be_nil }
    its(:message) { should eq 'The API did not respond in a reasonable amount of time' }
  end
end
