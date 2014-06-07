module Australium
  class MapStart < Event

    LOG_REGEX = /Started map "(?<map_name>.+)" \(CRC "(?<crc>.+)"\)/

    # @!attribute map_name
    #   @return [String] the name of the map that was started.

    # @!attribute crc
    #   @return [String] CRC of the map.

  end
end
