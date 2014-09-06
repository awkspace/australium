module Australium

  # Represents a generic Event that occurs during a Game.
  class Event < OpenStruct
    using MatchDataToHash

    # @!attribute raw
    #   @return [String] the raw log message.

    TIMESTAMP_REGEX = %r(L [0-9]{2}/[0-9]{2}/[0-9]{4} - [0-9]{2}:[0-9]{2}:[0-9]{2})
    PROPERTY_REGEX = /\(([^ ]+) "([^"]+)"\)/

    TIMESTAMP_FORMAT = 'L %m/%d/%Y - %H:%M:%S'

    class << self
      attr_accessor :event_classes
      def inherited(by)
        @event_classes ||= []
        @event_classes << by
      end
    end

    def initialize(data)
      super(data)

      # Replace anything matching a Player string with a Player object.
      self.each_pair do |key, value|
        if value =~ Player::LOG_REGEX && key != :raw
          player_data = Player::LOG_REGEX.match(value).to_h
          self[key] = Player.new(player_data)
        end
      end

      # If we're being stateful, make sure referenced Players are included in the GameState
      unless self.state.nil?
        self.to_h.select { |_, v| v.is_a?(Player) }.each_pair do |key, value|
          if self.state.players.include?(value)
            self[key] = self.state.players.find { |p| p == value }
          else
            self.state.players << value
          end
        end
      end
    end

    def to_s ; raw end

  end
end
