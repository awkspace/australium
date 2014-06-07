module Australium
  class PlayerKill < Event

    LOG_REGEX = /"(?<attacker>.+)" killed "(?<victim>.+)" with "(?<weapon>[^"]+)"/

    # @!attribute attacker
    #   @return [Player] the {player} responsible for the kill.
    # @!attribute victim
    #   @return [Player] the {player} who was killed.
    # @!attribute weapon
    #   @return [String] the name of the weapon used to kill (can be World).

  end
end
