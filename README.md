# Sick Beard

The `sick-beard` gem provides a Ruby interface for interacting with the [Sick Beard PRV API](http://sickbeard.com/api/). Pull requests are always welcome.

## Badges!

[![Gem Version](https://badge.fury.io/rb/sick-beard.png)](http://badge.fury.io/rb/sick-beard)
[![Build Status](https://travis-ci.org/RLovelett/sick-beard.png?branch=master)](https://travis-ci.org/RLovelett/sick-beard)
[![Coverage Status](https://coveralls.io/repos/RLovelett/sick-beard/badge.png?branch=master)](https://coveralls.io/r/RLovelett/sick-beard?branch=master)

## Author

[Ryan Lovelett](http://ryan.lovelett.me/) ( [@rlovelett](http://twitter.com/#!/rlovelett) )

Drop me a message for any questions, suggestions, requests, bugs or
submit them to the [issue
log](https://github.com/rlovelett/sick-beard/issues).

## Installation

Add this line to your application's Gemfile:

    gem 'sick-beard'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install sick-beard

## Usage

    require 'sickbeard'
    SickBeard.key = 'b41c7591977d20e3582774105246e916'
    SickBeard.client = 'http://example.com/'

    shows = SickBeard::Shows.new
    shows.map { |show| show.name } # Array of all the show names
    mythbusters = shows[73388] # Return the show with the specified TVDBID

    mythbusters.sync # Get all information about the show from Sick
Beard
    puts mythbusters.name # MythBusters
    puts mythbusters.episodes.count # 255
    puts mythbusters.episodes.first.name # MythBusters Young Scientists
Special
    puts mythbusters.episodes.first.location # nil

    mythbusters.episode.first

The specs for this Gem should give you some idea of how to make use of
the API. For now they will be the usage information. As always Pull
Requests for better documentation are welcome.

## Testing

The tests for the API have been mocked using [VCR](https://github.com/vcr/vcr) and [WebMock](https://github.com/bblimke/webmock).

Actual calls to a Sick Beard have been mocked out to prevent storage of valid API credentials and making superflous API calls while testing. As such, in order to run existing tests, using the mocked API requests, the only thing that needs to be done is to run the specs (e.g., `bundle exec rake spec` or `bundle exec guard start`).

However, if you want to refresh the actual server API responses you will need to re-record all of the VCR cassettes. This can be achieved simply by performing the following two steps:

1. Delete all the cassettes (`rm spec/cassettes/*.yml`)
2. Run specs passing the API key as environment variable (`SICKBEARD_API_URI='http://uri.to/sickbeard' SICBEARD_API_KEY=realapikey bundle exec rake spec`)

## Contributing

1. Fork it
2. Create a topic branch (`git checkout -b topic`)
3. Make your changes
4. Squash your changes into one commit
5. Create new Pull Request against this squashed commit

## Aknowlegements

This is a permanent fork of [bigkevmcd / sickbeard](https://github.com/bigkevmcd/sickbeard). Thank you to Kevin McDermott for a starting point.
