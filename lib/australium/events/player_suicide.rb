module Australium
  class PlayerSuicide < Event

    LOG_REGEX = /"(?<player>.+)" committed suicide with "(?<weapon>[^"]+)"/

    # @!attribute player
    #   @return [Player] the {Player} who committed suicide.
    # @!attribute weapon
    #   @return [String] the name of the weapon the player committed suicide with (can be World).

  end
end
