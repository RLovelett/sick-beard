require 'spec_helper'

describe SickBeard::Episodes, vcr: {
  cassette_name: 'sickbeard_episodes',
  record: :new_episodes,
  match_requests_on: [:query]
} do
  before(:each) do
    SickBeard.key = api_key
    SickBeard.client = api_uri
  end
  let(:episodes) { SickBeard::Episodes.new(73388) }
  subject { episodes }
  it { should have(255).episodes }
  it { subject.first.should be_an_instance_of(SickBeard::Episode) }
end
