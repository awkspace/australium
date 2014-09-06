module Australium
  class PlayerSay < Event

    LOG_REGEX = /"(?<player>.+)" say(?<team>_team)? "(?<message>.+)"/

    # @!attribute player
    #   @return [Player] the {Player} who spoke in chat.
    # @!attribute message
    #   @return [String] the message spoken.

    def initialize(data)
      super(data)
      self[:team] = team.eql?('_team')

      player[:connected?, timestamp] = true
      player[:in_game?, timestamp] = true
    end

    # Checks if the message was a team-only message.
    # @return [Boolean] true if the message was a team message.
    def team? ; team end

  end
end
