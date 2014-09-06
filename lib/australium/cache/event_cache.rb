require 'yaml'

module Australium

  # Allows access to events in an Australium database.
  # Unlike a direct Mongo connection, the EventCache will return a fully-formed Event object.
  class EventCache
    class << self
      private
      def event_filter(event_name, event_class)
        define_method(event_name) { @db[event_class.name.split('::').last] }
      end
    end
    include EventFilters

    attr_accessor :db

    # Creates a new instance of EventCache.
    # @param [Mongo::Database] db
    def initialize(db)
      @db = db
    end

    # Returns true if this game's data has been cached.
    # @param [Fixnum] game_hash hash of a game_log
    # @return [TrueClass] whether or not the data from this game_log has been cached
    def has_game?(game_hash)
      begin
        @db["MapLoad"].find(:game_id => game_hash).to_a.count > 0 && @db["GameEnd"].find(:game_id => game_hash).to_a.count > 0
      rescue
        false
      end
    end

    # Passes a block to the database object and returns reconstructed Events.
    # @param [Proc] block the queries to act on the database object
    # @return [Array<Event>] the reconstructed Event object or objects, if reconstruction was successful
    def query(&block)
      events = instance_exec(&block)

      # Raise an exception if results are not in the expected format.
      raise CacheReadError unless events.is_a?(Mongo::Cursor)

      events = events.to_a

      # Convert from hashes to objects.
      events.map { |event| hash_to_obj(event) }
    end

    # FIXME: This could be more clever.
    def hash_to_obj(hash)
      hash.each_pair do |key, value|
        hash[key] = hash_to_obj(value) if value.is_a?(Hash)
        hash[key] = value.map { |x| hash_to_obj(x) if x.is_a?(Hash) } if value.is_a?(Array)
      end

      begin
        obj_class = Australium.const_get(hash[:class])
      rescue
        obj_class = OpenStruct
      end

      obj_class.new(hash)
    end

    # FIXME: This could be more clever, and probably combined with hash_to_obj.
    def obj_to_hash(obj)
      obj.each_pair do |key, value|
        obj[key] = obj_to_hash(value) if value.is_a?(OpenStruct)
        obj[key] = value.map { |x| obj_to_hash(x) if x.is_a?(OpenStruct) } if value.is_a?(Array)
      end

      obj[:class] = obj.class.to_s.split('::').last

      obj.to_h
    end

    # Caches a complete {Game}.
    # @param [Australium::Game] game game to be added to the cache
    def store(game)

      # If a MapLoad event exists with identical parameters for everything except the game hash, delete the previous
      # game data - as this indicates an invalid or incomplete log was stored.
      start_event = game.map_loads.first
      matches = db["MapLoad"].find(
        :server => start_event.server,
        :timestamp => start_event.timestamp,
        :game_id => { "$ne" => start_event.game_id }
      ).to_a
      matches.each do |match|
        invalid_game = match['game_id']
        puts "Removing data from game #{invalid_game} as an incomplete cache."
        @db.collections.each do |collection|
          next if collection.name.start_with?("system.")
          collection.remove(:game_id => invalid_game)
        end
      end

      to_store = game.events.map do |event|

        # Due to the enormous amount of repeated information, saving GameState objects is not a sane proposition at
        # this time. Until GameState objects can be stored more efficiently, they will not be inserted into databases.
        event.delete_field(:state) unless event.is_a?(GameEnd)

        obj_to_hash(event)

      end

      to_store.each do |event|
        db[event[:class]].update(
          {:server => event[:server],
           :game_id => event[:game_id],
           :line_number => event[:line_number]},
          event,
          {:upsert => true}
        )
      end

    end

  end

end
