module Australium

  class Parser
    using MatchDataToHash
    using OpenStructDeepClone

    # Parses a full TF2 log.
    # @param [Array<String>] lines the lines to parse
    # @return [Array<Game>] the game(s) data
    def self.parse(lines)
      games = []

      game_lines = lines.slice_before(MapLoad::LOG_REGEX).select { |l| l.first =~ MapLoad::LOG_REGEX }

      game_lines.each do |lines|
        state = GameState.new
        state.game_id = lines.hash
        events = []

        lines.each_with_index do |line, index|
          event = parse_line(line, index, state)
          unless event.nil?
            events << event
            state = event.state.deep_clone
          end
        end

        games << Game.new(events) unless events.empty?
      end

      games
    end

    # Parses a single line of TF2 log in the context of a game (if a {GameState} is passed).
    # @param [String] line the line to be parsed
    # @param [Integer] line_number the index of the line
    # @param [GameState] state the {GameState} containing the game context.
    # @return [Event, NilClass] event if an event has been recognized; nil otherwise.
    def self.parse_line(line, line_number, state = nil)
      Event::event_classes.each do |event_class|
        if event_class::LOG_REGEX =~ line
          # Get timestamp data & timestamp GameState if we are being stateful
          timestamp = DateTime.strptime(Event::TIMESTAMP_REGEX.match(line)[0], 'L %m/%d/%Y - %H:%M:%S')
          state.timestamp = timestamp unless state.nil?

          # Get the meat of the event data
          data = event_class::LOG_REGEX.match(line).to_h

          # Get supplemental property data, if any exists
          property_data = line.scan(Event::PROPERTY_REGEX).map { |x| [x.first.to_sym, x.last] }.to_h
          data.merge!(property_data)

          # Add other useful data
          data[:line_number] = line_number
          data[:state] = state
          data[:raw] = line
          data[:timestamp] = timestamp
          data[:game_id] = state.game_id unless state.nil?

          # Construct and return the new Event
          return event_class.new(data)
        end
      end
      nil
    end

  end

end
