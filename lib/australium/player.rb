module Australium

  # Represents a Player playing a Game.
  class Player < TimedOpenStruct

    LOG_REGEX = /(?<nick>.*)<(?<won_id>.*)><(?<steam_id>.*)><(?<team>.*)>/

    # @!attribute nick
    #   @return [String] the player's in-game nickname.
    # @!attribute won_id
    #   @return [String] the player's {http://wiki.hlsw.net/index.php/WONID WONID}.
    # @!attribute steam_id
    #   @return [String] the player's unique Steam ID, or 'BOT' if this player is a bot.
    # @!attribute team
    #   @return [String] the name of the team the player is on (can be an empty string).

    def initialize(*args)
      super(*args)

      # Change steamIDs from the old format to the new one
      match = self[:steam_id].match(/STEAM_0:([0-9]+):([0-9]+)/)
      unless match.nil?
        begin
          self[:steam_id] = "[U:1:#{match[2].to_i * 2 + match[1].to_i}]"
        rescue nil ; end
      end

      # @!attribute address
      #   @return [String, NilClass] the player's IP address, or nil if not known
      self[:address] = nil

      # @!attribute in_game?
      #   @return [Boolean] true if the player is in the game (as determined by a triggered {PlayerEnterGame} event).
      self[:in_game?] = false

      # @!attribute connected?
      #   @return [Boolean] true if the player is currently connected to the server
      self[:connected?] = false

      # @!attribute role
      #   @return [String, NilClass] the name of the role the player is playing, or nil if none yet
      self[:role] = nil

    end

    # @!method ==(player)
    # @!method eql?(player)
    # Compares players by steam IDs and bots by nicks.
    # @param player [Player] the player to compare against
    # @return [Boolean]
    [:==, :eql?].each do |method|
      define_method(method) do |player|
        if [self, player].all?(&:bot?)
          self.nick.send(method, player.nick)
        else
          self.steam_id.send(method, player.steam_id)
        end
      end
    end

    # Checks if the player is a bot.
    # @return [Boolean] true if the player is a bot
    def bot? ; self.steam_id == 'BOT' end

    # Checks if the player is on the BLU team.
    # @return [Boolean] true if the player is on the BLU team
    def blu? ; self.team == 'Blue' end

    # Checks if the player is on the RED team.
    # @return [Boolean] true if the player is on the RED team
    def red? ; self.team == 'Red' end

    # Checks if the player is a spectator.
    # @return [Boolean] true if the player is a spectator
    def spectator? ; self.team == 'Spectator' end

    # Checks if the player is not assigned to any team. (This can be considered a fourth team in some contexts.)
    # @return [Boolean] true if the player is unassigned
    def unassigned? ; self.team == 'Unassigned' end

    # Checks if the player is in the game as either a RED or BLU player.
    # @return [Boolean] true if the player is either on RED or BLU
    def has_team? ; blu? || red? end

  end
end
