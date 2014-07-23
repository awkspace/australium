module Australium
  class PlayerDisconnect < Event

    LOG_REGEX = /"(?<player>.+)" disconnected/

    # @!attribute player
    #   @return [Player] the {Player} who disconnected from the server.

    def initialize(data)
      super(data)
      player[:connected?, timestamp] = false
      player[:in_game?, timestamp] = false
    end

  end
end
