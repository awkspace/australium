path = File.dirname(__FILE__)

require 'ostruct'
require 'date'

Dir["#{path}/Australium/ref/*.rb"].each { |f| require f }

require "#{path}/Australium/event.rb"
Dir["#{path}/Australium/events/*.rb"].each { |f| require f }

Dir["#{path}/Australium/*.rb"].each { |f| require f }

module Australium

  # Parses a file located at the given path and returns an array of {Game}s.
  # @param [String] logfile the location of the logfile.
  # @return [Array<Game>] the parsed game data.
  def self.parse_file(logfile)
    log = File.read(logfile)
    Parser::parse(log.split("\n"))
  end

  # Future expansion: #parse should be able to determine the kind of input given and parse accordingly - i.e.
  # a past logfile vs a logfile currently being written to vs a network stream.
  class << self
    alias_method :parse, :parse_file
  end

end
