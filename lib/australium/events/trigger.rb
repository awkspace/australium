module Australium
  # A Trigger Event is a very general Event. Triggers occur on point capture, round end, even damage and healing
  # with plugins installed. Depending on the kind of trigger, it could involve one player, two players, or no
  # players at all (in the case of 'World' triggering an event, such as a round end).
  class Trigger < Event

    LOG_REGEX = /: "?(?<initiator>.*(World|>))"? triggered "(?<action>[^"]+)"(?: against "(?<target>.+>)")?/

    # @!attribute initiator
    #   @return [Player, String] the {Player} who triggered the event, or the string 'World'
    # @!attribute action
    #   @return [String] the name of the triggered action.
    # @!attribute target
    #   @return [Player, NilClass] the {Player} who received the action, or nil if no {Player} received the action.

  end
end
