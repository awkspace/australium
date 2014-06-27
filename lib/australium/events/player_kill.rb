module Australium
  class PlayerKill < Event

    LOG_REGEX = /"(?<attacker>.+)" killed "(?<victim>.+)" with "(?<weapon>[^"]+)"/

    # @!attribute attacker
    #   @return [Player] the {Player} responsible for the kill.
    # @!attribute victim
    #   @return [Player] the {Player} who was killed.
    # @!attribute weapon
    #   @return [String] the name of the weapon used to kill (can be World).

  end
end
