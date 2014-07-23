module Australium
  class PlayerRoleChange < Event

    LOG_REGEX = /"(?<player>.+)" changed role to "(?<role>.+)"/

    # @!attribute player
    #   @return [Player] the {Player} who changed role.
    # @!attribute role
    #   @return [String] the name of the role the player changed to.

    def initialize(data)
      super(data)
      player.role = role

      player[:connected?, timestamp] = true
      player[:in_game?, timestamp] = true
    end

  end
end
