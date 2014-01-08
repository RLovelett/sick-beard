module SickBeard

  def self.client
    @client ||= SickBeard::Client.new('example.com', 12345)
    @client
  end

  ##
  # Set the default client to be used by Sick Beard helper classes.
  # @options [String,URI,Client]
  def self.client=(new_client)
    if new_client.is_a?(String)
      new_client = URI.parse(new_client)
    end
    @client = if new_client.is_a?(SickBeard::Client)
                new_client
              elsif new_client.is_a?(URI)
                SickBeard::Client.new(new_client.host, self.key, new_client.scheme, new_client.port)
              end
    @client
  end

  def self.key
    @key ||= ''
    @key
  end

  def self.key=(new_key)
    @key = new_key
    @key
  end

  LIBRARY_PATH = File.join(File.dirname(__FILE__), 'sickbeard')

  autoload :Client, File.join(LIBRARY_PATH, 'client')
  autoload :URI, File.join(LIBRARY_PATH, 'client')
  autoload :ClientResponse, File.join(LIBRARY_PATH, 'client_response')
  autoload :Shows, File.join(LIBRARY_PATH, 'shows')
  autoload :Show, File.join(LIBRARY_PATH, 'show')
  autoload :Episodes, File.join(LIBRARY_PATH, 'episodes')
  autoload :Episode, File.join(LIBRARY_PATH, 'episode')
  autoload :Exception, File.join(LIBRARY_PATH, 'exception')
end
