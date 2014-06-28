module Australium
  class PlayerEnterGame < Event

    LOG_REGEX = /"(?<player>.+)" entered the game/

    # @!attribute player
    #   @return [Player] the {Player} who entered the game. This event always takes place after a corresponding
    #     {PlayerConnect} event.

    def initialize(data)
      super(data)
      player[:in_game?] = true
    end

  end
end
