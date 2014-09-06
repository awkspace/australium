module Australium

  # A special Event injected by Australium to indicate the end of a {Game} log.
  # Note that this may not be the actual end of a game, i.e. if logging was interrupted, but it is the end of what
  # Australium has available to parse.
  class GameEnd < Event

    def initialize(data)
      super(data)

      unless self.state.nil? || self.state.players.nil?
        self.state.players.each do |player|

          [:connected?, :in_game?].each { |attr| player[attr, timestamp] = false }

          player.time_connected = player.durations(:connected?)[true] rescue 0
          player.time_ingame = player.durations(:in_game?)[true] rescue 0

        end
      end
    end

  end

end
