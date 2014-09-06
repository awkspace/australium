module Australium
  class PlayerJoinTeam < Event

    LOG_REGEX = /"(?<player>.+)" joined team "(?<team>.+)"/

    # @!attribute player
    #   @return [Player] the {Player} who joined the team.
    # @!attribute team
    #   @return [String] the name of the team the player joined.

    def initialize(data)
      super(data)
      player.team = team

      player[:connected?, timestamp] = true
      player[:in_game?, timestamp] = true
    end

  end
end
