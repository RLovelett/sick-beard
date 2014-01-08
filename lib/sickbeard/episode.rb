module SickBeard
  class Episode
    attr_reader :tvdbid, :season, :episode, :airdate, :description, :file_size,
      :file_size_human, :location, :name, :quality, :release_name, :status

    def initialize(options = {})
      if options.is_a?(Hash)
        parse(options)
      elsif options.is_a?(SickBeard::ClientResponse)
        parse(options.data) if options.success?
      else
        raise ::ArgumentError, "Expected Hash or SickBeard::ClientResponse, found #{options.class}"
      end
    end

    def parse(options = {})
      options[:tvdbid] = tvdbid unless tvdbid.nil?
      options[:season] = season unless season.nil?
      options[:episode] = episode unless episode.nil?

      # Raise error if improperly initialize show
      raise SickBeard::Exception, "Must provide a TVDBID to create a new Show\n#{JSON.pretty_generate(options)}" unless options.key?(:tvdbid) and options[:tvdbid].is_a?(Fixnum)

      # Parse options to instance variables
      @tvdbid = options[:tvdbid]
      @season = options[:season]
      @episode = options[:episode]
      @airdate = options[:airdate]
      @airdate = Date.parse(@airdate) unless @airdate.nil? or @airdate.empty?
      @name = options[:name]
      @description = options[:description]
      @file_size = options[:file_size]
      @file_size_human = options[:file_size_human]
      @location = options[:location]
      @release_name = options[:release_name]
      @quality = options[:quality]
      @status = options[:status]
    end

    ##
    # Sync the local Show object with data from Sick Beard
    def sync(client = SickBeard.client)
      uri = client.uri('episode', tvdbid, {
        season: season,
        episode: episode,
        full_path: 1
      })
      response = Client.request(uri)
      parse(response.data) if response.success?
    end
  end
end
