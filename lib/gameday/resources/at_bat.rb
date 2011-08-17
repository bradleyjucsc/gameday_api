
module Gameday
  # This class represents a single atbat during a single game
  class AtBat < Resource

    attr_accessor :gid, :inning, :away_team, :home_team
    attr_accessor :num, :b, :s, :o, :batter, :stand, :b_height, :pitcher, :p_throws, :des, :event
    attr_accessor :pitches

    def self.new_from_xml element, gid, inning
      at_bat = super element

      at_bat.inning = inning
      at_bat.gid = gid
      at_bat.set_pitches element

      at_bat
    end


    def set_pitches(element)
      @pitches = []
      element.elements.each("pitch") do |element|
        pitch = Pitch.new
        pitch.init(element)
        @pitches << pitch
      end
    end


  end
end