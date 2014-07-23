module Australium

  class Parser
    using MatchDataToHash
    using OpenStructDeepClone

    # Splits a TF2 logfile into an array of individual lines.
    # @param [String] filename the location of the log file to parse
    # @return [Array<String>] an array of log entries
    def self.parse_file(logfile)
      File.read(logfile).encode('UTF-8', :invalid => :replace, :replace => '').split("\n")
    end

    # Splits a TF2 file log into individual game logs, dumping anything extraneous.
    # @param [Array<String>] file_log the file log to parse
    # @return [Array<Array<String>>] an array of one or more game logs
    def self.parse_file_log(file_log)
      file_log.slice_before(MapLoad::LOG_REGEX).select { |l| l.first =~ MapLoad::LOG_REGEX }
    end

    # Calculates a SHA1 digest of a game_log. Used for identifying unique {Game}s.
    # @param [Array<String>] game_log the game log to hash
    # @return [String] SHA1 hash of the game_log
    def self.game_log_digest(game_log)
      Digest::SHA1.hexdigest(game_log.join("\n"))
    end

    # Parses a log of a full TF2 game.
    # @param [Array<String>] lines the lines to parse
    # @param [Hash] properties an optional hash of properties to pass into the event objects
    # @return [Array<Game>] the game data
    def self.parse_game_log(lines, properties = {})
      state = GameState.new
      state.game_id = game_log_digest(lines)
      events = []

      lines.each_with_index do |line, index|
        event = parse_line(line, index, state)
        unless event.nil?
          properties.each_pair { |key, value| event[key] = value }
          events << event
          state = event.state.deep_clone
        end
      end

      if events.empty?
        nil
      else
        events << GameEnd.new(
          :line_number => events.last.line_number + 1,
          :timestamp => events.last.timestamp,
          :server => events.last.server,
          :game_id => events.last.game_id,
          :state => (events.last.state.deep_clone rescue nil)
        )
        Game.new(events)
      end
    end

    # Parses a single line of TF2 log in the context of a game (if a {GameState} is passed).
    # @param [String] line the line to be parsed
    # @param [Integer] line_number the index of the line
    # @param [GameState] state the {GameState} containing the game context.
    # @return [Event, NilClass] event if an event has been recognized; nil otherwise.
    def self.parse_line(line, line_number, state = nil)
      Event::event_classes.each do |event_class|
        next unless defined?(event_class::LOG_REGEX)
        if event_class::LOG_REGEX =~ line
          # Get timestamp data & timestamp GameState if we are being stateful
          timestamp = Time.strptime(Event::TIMESTAMP_REGEX.match(line)[0], Event::TIMESTAMP_FORMAT)
          state.timestamp = timestamp unless state.nil?

          # Get the meat of the event data
          data = event_class::LOG_REGEX.match(line).to_h

          # Get supplemental property data, if any exists
          property_data = line.scan(Event::PROPERTY_REGEX).map { |x| [x.first.to_sym, x.last] }.to_h
          data.merge!(property_data)

          # Add other useful data
          data.merge!({
            :line_number => line_number,
            :state => state,
            :raw => line,
            :timestamp => timestamp,
            :game_id => (state.nil? ? nil : state.game_id)
          })

          # Construct and return the new Event
          return event_class.new(data)
        end
      end
      nil
    end

  end

end
