module Gameday
  # This class represents a batting record for a single player for a single game
  # Note that this does NOT represent a single atbat of a player, but rather an appearance is a player's stats over an entire game.
  class BattingAppearance < Resource
  
    attr_accessor :pid, :batter_name, :pos, :bo, :ab, :po, :r, :bb, :a, :t, :sf, :h, :e, :d, :hbp, :so, :hr, :rbi, :lob, :sb, :avg, :fldg
    attr_accessor :player, :atbats

    def self.new_from_xml element
      ba = super element

      ba.pid = element.attributes['id']
      ba.batter_name = element.attributes['name']

      ba
    end


    # Looks up the player record using the players.xml file for the player in this appearance
    def get_player
      if !self.player
        # retrieve player object
        player = Player.new
        player.init()
        self.player = player
      end
      self.player
    end
  
  
    # get the atbats associated with this appearance
    def get_atbats
    
    end
  
  end
end