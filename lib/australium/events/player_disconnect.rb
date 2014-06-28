module Australium
  class PlayerDisconnect < Event

    LOG_REGEX = /"(?<player>.+)" disconnected/

    # @!attribute player
    #   @return [Player] the {Player} who disconnected from the server.

    def initialize(data)
      super(data)
      state.players.delete(player) unless state.nil?
    end

  end
end
