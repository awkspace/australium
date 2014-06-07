module Australium
  class PlayerRoleChange < Event

    LOG_REGEX = /"(?<player>.+)" changed role to "(?<role>.+)"/

    # @!attribute player
    #   @return [Player] the {Player} who changed role.
    # @!attribute role
    #   @return [String] the name of the role the player changed to.

    def initialize(data)
      super(data)
      unless state.nil?
        player = state.players.find { |p| p.nick == self.player.nick }
        player.role = role
      end
    end

  end
end
