module Australium
  class PlayerConnect < Event

    LOG_REGEX = /"(?<player>.+)" connected, address "(?<address>.+)"/

    # @!attribute player
    #   @return [Player] the {Player} who connected to the server.
    # @!attribute address
    #   @return [String] the IP address of the connecting player.

    def initialize(data)
      super(data)
      player.address = address
      player[:connected?, timestamp] = true
    end

  end
end
