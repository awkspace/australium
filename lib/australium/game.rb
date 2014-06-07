module Australium

  # Represents a full game of TF2, comprised of individual {Event}s.
  class Game

    class << self
      private
      # Creates shortcuts for returning events of a certain type.
      # @param [Symbol] event_name the friendly name of the event category
      # @param [Class] event_class the class name corresponding to the event
      # @!macro [attach] event_selector
      #   @!method $1
      #   @return [Array<$2>] Returns all {$2 $2} events.
      def event_selector(event_name, event_class)
        define_method(event_name) { @events.select { |e| e.is_a?(event_class) } }
      end
    end

    # @!attribute [r] events
    #   @return [Array<Events>] events that took place during the game, in chronological order
    attr_reader :events

    # @param events [Array<Events>] events that took place during the game
    def initialize(events)
      @events = events
    end

    # Returns an array of all {Player Players} who connected to the server during this game.
    # Caches the return value after the first call.
    # @return [Array<Player>] players who participated in the game
    def players
      @players ||= @events.reverse.each_with_object([]) do |event, all_players|
        break all_players if event.state.nil? || event.state.players.nil?
        all_players.concat event.state.players.reject { |p| all_players.include?(p) }
      end
    end

    # Returns the name of the map that was played.
    # @return [String] map name
    def map_name
      @events.select { |e| e.is_a?(MapStart) }.last.map_name
    end

    # @!group Event filters
    event_selector :connects,      PlayerConnect
    event_selector :disconnects,   PlayerDisconnect
    event_selector :role_changes,  PlayerRoleChange
    event_selector :team_joins,    PlayerJoinTeam
    event_selector :kills,         PlayerKill
    event_selector :name_changes,  PlayerNameChange
    event_selector :chat_messages, PlayerSay
    event_selector :suicides,      PlayerSuicide
    event_selector :triggers,      Trigger
    # @!endgroup

    # Hide instance variables from #inspect to prevent clutter on interactive terminals.
    # @return [String]
    def inspect ; self.to_s end

  end
end
