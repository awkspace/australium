module Australium
  class PlayerNameChange < Event

    LOG_REGEX = /"(?<player>.+)" changed name to "(?<new_name>.+)"/

    # @!attribute player
    #   @return [Player] the {Player} whose name changed.
    # @!attribute new_name
    #   @return [String] the name the player changed to.

    def initialize(data)
      super(data)
      player.nick = new_name
    end

  end
end
