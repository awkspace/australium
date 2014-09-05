path = File.dirname(__FILE__)

require 'ostruct'
require 'date'
require 'time'

Dir["#{path}/australium/ref/*.rb"].each { |f| require f }

require "#{path}/australium/event.rb"
Dir["#{path}/australium/events/*.rb"].each { |f| require f }

require "#{path}/australium/event_filters.rb"
Dir["#{path}/australium/*.rb"].each { |f| require f }

module Australium

  # Parses a file located at the given path and returns an array of {Game}s.
  # @param [String] logfile the location of the logfile.
  # @return [Array<Game>] the parsed game data.
  def self.parse_file(logfile)
    file_log = Parser::parse_file(logfile)
    game_logs = Parser::parse_file_log(file_log)
    game_logs.map do |game_log|
      Praser::parse_game(game_log)
    end
  end

  # Future expansion: #parse should be able to determine the kind of input given and parse accordingly - i.e.
  # a past logfile vs a logfile currently being written to vs a network stream.
  class << self
    alias_method :parse, :parse_file
  end

end
