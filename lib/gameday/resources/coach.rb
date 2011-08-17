module Gameday
  # This class represents a single MLB coach
  class Coach < Resource

    attr_accessor :position, :first, :last, :id, :num

    def self.new_from_xml element
      coach = super element

      coach.id = element.attributes['id']

      coach
    end
  end
end