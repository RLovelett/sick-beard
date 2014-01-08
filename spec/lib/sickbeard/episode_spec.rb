require 'spec_helper'

describe SickBeard::Episode, vcr: {
  cassette_name: 'sickbeard_episode',
  record: :new_episodes,
  match_requests_on: [:query]
} do
  before(:each) do
    SickBeard.key = api_key
    SickBeard.client = api_uri
  end
  let(:ep) do
    SickBeard::Episode.new(
      tvdbid: 73388,
      season: 13,
      episode: 1
    )
  end
  subject { ep }
  its(:tvdbid) { should eq 73388 }
  its(:season) { should eq 13 }
  its(:episode) { should eq 1 }

  describe 'sync' do
    before(:each) { ep.sync }
    its(:tvdbid) { should eq 73388 }
    its(:season) { should eq 13 }
    its(:episode) { should eq 1 }
    its(:airdate) { should be_an_instance_of(Date) }
    its(:description) { should eq "In this Star Wars special, the MythBusters test if Luke really could swing himself and Leia across a chasm with only his belt-rigged grappling hook, could an Ewok log swing crush an Imperial \"Chicken Walker\", and could Luke survive in a tauntaun's belly?" }
    its(:file_size) { should eq 1522149708 }
    its(:file_size_human) { should eq '1.42 GB' }
    its(:location) { should eq '/pond/recorded-tv/MythBusters/13x01.mkv' }
    its(:name) { should eq 'Star Wars:  Revenge of the Myth' }
    its(:quality) { should eq 'HD TV' }
    its(:release_name) { should eq 'MythBusters.S13E01.Star.Wars.Revenge.of.the.Myth.720p.HDTV.x264-DHD' }
    its(:status) { should eq 'Downloaded' }
  end
end
