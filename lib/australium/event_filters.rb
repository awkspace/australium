module Australium

  # Creates a set of helper methods for all classes containing {Event}s.
  # The #event_filter method must be overridden in the class including this module, and should generate
  # a method that returns an Array<Event>.
  module EventFilters

    class << self
      private
      # Call the overridden #event_filter on the class for each shortcut.
      # @param [Class] by the class including this module
      def included(by) @filters.each { |args| by.send(:event_filter, *args) } end

      public
      # Creates shortcuts for returning events of a certain type.
      # @param [Symbol] friendly_name the friendly name of the event group requested
      # @param [Class] class_name the class name of the requested events
      def event_filter(*args); @filters ||= [] ; @filters << args end
    end

    # @!macro [attach] event_filter
    #   @!method $1
    #   @return [Array<$2>] Returns all {$2} events.
    event_filter :map_loads,     MapLoad
    event_filter :map_starts,    MapStart
    event_filter :connects,      PlayerConnect
    event_filter :disconnects,   PlayerDisconnect
    event_filter :role_changes,  PlayerRoleChange
    event_filter :team_joins,    PlayerJoinTeam
    event_filter :kills,         PlayerKill
    event_filter :name_changes,  PlayerNameChange
    event_filter :chat_messages, PlayerSay
    event_filter :suicides,      PlayerSuicide
    event_filter :triggers,      Trigger

  end

end
