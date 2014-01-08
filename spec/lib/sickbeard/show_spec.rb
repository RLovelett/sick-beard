require 'spec_helper'

describe SickBeard::Show, vcr: {
  cassette_name: 'sickbeard_show',
  record: :new_episodes,
  match_requests_on: [:query]
} do
  before(:each) do
    SickBeard.key = api_key
    SickBeard.client = api_uri
  end

  context 'only required params' do
    let(:show) { SickBeard::Show.new(tvdbid: 73388) }
    subject { show }
    its(:tvdbid) { should eq 73388 }
    its(:name) { should be_nil }
    its(:genres) { should be_nil }
  end

  context 'valid Show initialization' do
    let(:options) do
      JSON.parse(
        '{"air_by_date":0,"cache":{"banner":1,"poster":1},"language":"en","network":"Discovery","next_ep_airdate":"2014-01-11","paused":0,"quality":"HD720p","show_name":"MythBusters","status":"Continuing","tvdbid":73388,"tvrage_id":4605,"tvrage_name":"MythBusters"}',
        { symbolize_names: true }
      )
    end
    let(:show) { SickBeard::Show.new(options) }
    subject { show }
    it { should be_a(SickBeard::Show) }
    its(:show_name) { should eq('MythBusters') }
    its(:name) { should eq 'MythBusters' }
    its(:language) { should eq 'en' }
    its(:lang) { should eq 'en' }
    its(:network) { should eq 'Discovery' }
    its(:next_ep_airdate) { should be_a Date }
    its(:next_ep_airdate) { should eq Date.new(2014, 01, 11) }
    its(:paused) { should be_false }
    its(:quality) { should eq 'HD720p' }
    its(:status) { should eq 'Continuing' }
    its(:tvdbid) { should eq 73388 }
    its(:tvrage_id) { should eq 4605 }
    its(:tvrage_name) { should eq 'MythBusters' }
    its(:genres) { should be_nil }

    describe 'sync' do
      before(:each) { show.sync }
      its(:air_by_date) { should be_false }
      its(:airs) { should eq 'Saturday 8:00 PM' }
      its(:banner_cached?) { should eq true }
      its(:poster_cached?) { should eq true }
      its(:flatten_folders) { should be_false }
      its(:genres) { should have(3).items }
      its(:genres) { should include('Documentary', 'Reality', 'Special Interest') }
      its(:language) { should eq 'en' }
      its(:location) { should eq '/pond/recorded-tv/MythBusters' }
      its(:network) { should eq 'Discovery' }
      its(:next_ep_airdate) { should be_a Date }
      its(:next_ep_airdate) { should eq Date.new(2014, 01, 11) }
      its(:paused) { should be_false }
      its(:quality) { should eq 'HD720p' }
      its(:season_list) { should have(14).seasons }
      its(:show_name) { should eq 'MythBusters' }
      its(:status) { should eq 'Continuing' }
      its(:tvrage_id) { should eq 4605 }
      its(:tvrage_name) { should eq 'MythBusters' }
    end

    describe 'episodes' do
      context 'no filter' do
        subject { show.episodes }
        it { should have(255).episodes }
        it { subject.first.should be_an_instance_of(SickBeard::Episode) }
      end
    end
  end

  context 'invalid Show initialization' do
    it { expect{ SickBeard::Show.new(show_name: 'Mythbusters') }.to raise_error(SickBeard::Exception) }
  end
end
