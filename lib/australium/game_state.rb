module Australium

  # Represents the state of the game at a particular time.
  class GameState < OpenStruct

    def initialize(*args)
      super(*args)

      # @!attribute players
      #   @return [Array<Player>] player data at this state
      self.players ||= []

      # @!attribute timestamp
      #   @return [DateTime]
    end

    def inspect; "<GameState:#{timestamp}>" end

  end
end
