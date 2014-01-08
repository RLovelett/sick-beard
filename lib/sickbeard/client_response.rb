module SickBeard
  class ClientResponse

    # @!attribute [r] message
    #   @return [String] the error message returned by the Sick Beard API
    attr_reader :message

    ##
    # Create a new Response object
    # @option options [String] Raw body response from the Sick Beard API
    # @return [Object] the object.
    def initialize(raw_str)
      raise ::ArgumentError, "Must be a String found #{raw_str.class}" unless raw_str.is_a?(String)
      begin
        @body = JSON.parse(raw_str, { symbolize_names: true })
      rescue JSON::ParserError
        @body = {
          result: 'failure',
          message: 'Malformed JSON response',
          data: nil
        }
      end
      @success = if @body[:result] === 'success'
                   true
                 else
                   false
                 end
      @error = !@success
      @message = @body[:message]
      @data = @body[:data]
    end

    ##
    # If the API returned an error this will be false, otherwise, true.
    # @return [Boolean] indicating whether there was an error in the API call
    def success?
      @success
    end

    ##
    # If the API returned an error this will be true, otherwise, false.
    # @return [Boolean] indicates whether there was an error in the API call
    def error?
      !@success
    end

    ##
    # If the API responded with valid data it will be parsed and readable from
    # this property.
    #
    # @return [Hash|Array|nil] The parsed data object from the Sick Beard API
    def data
      @data unless error?
    end

    def to_s
      JSON.dump(@body)
    end
  end
end
