module SickBeard
  class Shows
    include Enumerable

    def initialize(client = SickBeard.client)
      @client = client
      @uri = @client.uri('shows', 1245)
      @shows = []

      response = Client.request(@uri)

      if response.success?
        puts "Class: #{response.data.class}"
        response.data.each_value do |obj|
          @shows << SickBeard::Show.new(obj)
        end
      else
        puts response.message
      end
    end

    def each &block
      @shows.each do |show|
        if block_given?
          block.call show
        else
          yield show
        end
      end
    end
  end
end
