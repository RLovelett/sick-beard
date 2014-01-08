require 'rest_client'
require 'uri'

module SickBeard
  class Client

    attr_reader :base_uri

    def initialize(hostname, key, scheme = 'http', port = 80)
      mod = case scheme
               when 'http'
                 URI::HTTP
               when 'https'
                 URI::HTTPS
               else
                 URI::Generic
               end
      @base_uri = mod.new(
        scheme,
        nil,
        hostname,
        port,
        nil,
        "/api/#{key}",
        nil,
        nil,
        nil,
        nil,
        true
      )
    end

    ##
    # Generate a new URI for 
    def uri(cmd, tvdbid, options = {})
      options = {
        cmd: cmd,
        tvdbid: tvdbid
      }.merge(options)

      uri = base_uri.clone
      uri.query = URI.encode_www_form(options)
      uri
    end

    ##
    # @returns [String] the base_uri to a String
    def to_s
      @base_uri.to_s
    end

    ##
    # @returns [ClientResponse] the formatted response from the Sick Beard API
    def self.request(uri)
      raise ::ArgumentError, "Must be an instance of URI, found #{uri.class} instead." unless uri.is_a?(URI)
      begin
        SickBeard::ClientResponse.new(RestClient.get(uri.to_s))
      rescue RestClient::RequestTimeout
        SickBeard::ClientResponse.new(TIMEOUT_JSON)
      rescue RuntimeError
        SickBeard::ClientResponse.new(TIMEOUT_JSON)
      end
    end

    private
    TIMEOUT_JSON='{"data":null,"message":"The API did not respond in a reasonable amount of time","result":"failure"}'
    RUNTIME_JSON='{"data":null,"message":"The server did not specify a message","result":"failure"}'
  end
end
