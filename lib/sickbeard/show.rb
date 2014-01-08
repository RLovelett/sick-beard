module SickBeard
  class Show
    # @!attribute [r] show_name
    #   @return [String] the name of the Show
    # @!attribute [r] name Alias to show_name
    #   @return [String] the name of the Show
    # @!attribute [r] language
    #   @return [String] the language the show is broadcast in
    # @!attribute [r] network
    #   @return [String] the network the show airs on
    # @!attribute [r] genres
    #   @return [Array(String)] genres for this Show
    # @!attribute [r] status
    #   @return [String] the status for this Show
    #     * Continuing
    #     * Ended
    # @!attribute [r] season_list
    #  @return [Array(String)] list of known Series for this Show
    # @!attribute [r] server
    #  @return [SickBeard::Client] the server this Show was loaded from
    # @!attribute [r] tvdbid
    #  @return [Integer] the tvdbid for this Show
    # @!attribute [r] quality
    #  @return [String] The download quality for this Show e.g. SD
    attr_reader :show_name, :language, :network, :next_ep_airdate, :paused,
      :quality, :status, :tvdbid, :tvrage_id, :tvrage_name, :genres, :location,
      :airs, :flatten_folders, :air_by_date, :season_list

    alias :name :show_name
    alias :lang :language

    # Create a new Show
    # @option options [String] :name ("") The name for this show
    # @option options [Array(String)] :genres ("") array of genres applicable to this show.
    # @return [Object] the object.
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
      # Generes can sometime be denoted as 'genre' or 'genres'
      #
      # This is an attempt to merge those conditions. Internally,
      # the class will map it to genres.
      #
      # It deletes the genre key if found and optionally returns an empty
      # array if not found
      if options.key?(:genre) or options.key?(:geres)
        genre_new = options.delete(:genre) { [] }
        genres_new = options.delete(:genres) { [] }
        options[:genres] = genre_new | genres_new
      end

      options[:tvdbid] = tvdbid unless tvdbid.nil?

      # Raise error if improperly initialize show
      raise SickBeard::Exception, "Must provide a TVDBID to create a new Show\n#{JSON.pretty_generate(options)}" unless options.key?(:tvdbid) and options[:tvdbid].is_a?(Fixnum)

      # Parse options to instance variables
      @language = options[:language]
      @network = options[:network]
      @next_ep_airdate = options[:next_ep_airdate]
      @next_ep_airdate = Date.parse(@next_ep_airdate) unless @next_ep_airdate.nil? or @next_ep_airdate.empty?
      @paused = int_to_bool(options[:paused])
      @quality = options[:quality]
      @show_name = options[:show_name]
      @status = options[:status]
      @tvdbid = options[:tvdbid]
      @tvrage_id = options[:tvrage_id]
      @tvrage_name = options[:tvrage_name]
      @genres = options[:genres]
      @season_list = options[:season_list].sort unless options[:season_list].nil?
      @location = options[:location]
      @airs = options[:airs]
      @flatten_folders = int_to_bool(options[:flatten_folders])
      @air_by_date = int_to_bool(options[:air_by_date])

      if options.key?(:cache)
        @banner_cached = int_to_bool(options[:cache][:banner])
        @poster_cached = int_to_bool(options[:cache][:poster])
      end
    end

    def banner_cached?
      @banner_cached
    end

    def poster_cached?
      @poster_cached
    end

    ##
    # 
    def episodes(force = false)
      @episodes = SickBeard::Episodes.new(tvdbid) if @episodes.nil? or force
      @episodes
    end

    ##
    # Sync the local Show object with data from Sick Beard
    def sync(client = SickBeard.client)
      uri = client.uri(:show, tvdbid)
      response = Client.request(uri)
      parse(response.data) if response.success?
    end

    private
    def int_to_bool(int)
      if int == 1
        true
      elsif int == 0
        false
      else
        !!int
      end
    end
  end
end
