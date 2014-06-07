module Australium
  class MapLoad < Event

    LOG_REGEX = /Loading map "(?<map_name>.+)"/

    # @!attribute map_name
    #   @return [String] the name of the loaded map.

  end
end
