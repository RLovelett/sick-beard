module SickBeard
  class Episodes
    include Enumerable

    attr_reader :tvdbid

    def initialize(tvdbid, client = SickBeard.client)
      @tvdbid = tvdbid
      @episodes = []

      uri = client.uri('show.seasons', tvdbid)
      response = SickBeard::Client.request(uri)

      if response.success?
        data = response.data
        data.each do |season_number, episodes|
          episodes.each do |ep_number, data|
            @episodes << SickBeard::Episode.new(
              tvdbid: tvdbid,
              season: season_number,
              episode: ep_number,
              airdate: data[:airdate],
              name: data[:name],
              quality: data[:quality],
              status: data[:status]
            )
          end
        end
      end
    end

    def each &block
      @episodes.each do |episode|
        if block_given?
          block.call episode
        else
          yield episode
        end
      end
    end

  end
end
