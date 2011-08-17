module Gameday
  class Event < Resource

    attr_accessor :number, :inning, :description, :team

    def self.new_from_xml element, home_or_away
      event = super element
      event.team = home_or_away

      event
    end
  end
end