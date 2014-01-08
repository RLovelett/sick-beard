require 'spec_helper'

describe SickBeard::Shows, vcr: {
  cassette_name: 'sickbeard_shows',
  record: :new_episodes,
  match_requests_on: [:query]
} do
  before(:each) do
    SickBeard.client = api_uri
    SickBeard.key = api_key
  end
  subject { SickBeard::Shows.new }
  it { expect(subject).to have(18).shows }
  it { expect(subject.first).to be_a(SickBeard::Show) }
end
