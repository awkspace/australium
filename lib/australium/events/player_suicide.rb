module Australium
  class PlayerSuicide < Event

    LOG_REGEX = /"(?<player>.+)" committed suicide with "(?<weapon>[^"]+)"/

    # @!attribute player
    #   @return [Player] the {Player} who committed suicide.
    # @!attribute weapon
    #   @return [String] the name of the weapon the player committed suicide with (can be World).

    def initialize(data)
      super(data)

      player[:connected?, timestamp] = true
      player[:in_game?, timestamp] = true
    end

  end
end
