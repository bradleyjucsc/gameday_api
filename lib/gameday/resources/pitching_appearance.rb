module Gameday
  # This class holds data that represents a single pitching appearance by a pitcher.
  class PitchingAppearance < Resource

    attr_accessor :pid, :gid, :pitcher_name, :out, :inn, :er, :r, :h, :so, :hr, :bb, :bf
    attr_accessor :w, :l, :era, :note, :start, :game
    attr_accessor :pitches, :b, :s, :x, :max_speed, :min_speed

    def self.new_from_xml gid, element, count
      appearance = super element
      appearance.gid          = gid
      appearance.pid          = element.attributes["id"]
      appearance.pitcher_name = element.attributes["name"]
      appearance.inn          = appearance.convert_out_to_inn(element.attributes['out'])

      appearance.start        = (1 == count)

      appearance
    end


    # Returns true if this appearance is a start
    def start?
      start
    end


    # Returns true if this was a quality start
    # A quality start is defined as being greater than or equal to 6 innings and allowing 3 runs or less
    def quality_start?
      if @inn.to_i >= 6 && @r.to_i < 4
        return true
      end
      return false
    end


    # Returns an array of the atbats against this pitcher during this game
    def get_vs_ab
      results = []
      abs = get_game.get_atbats
      abs.each do |ab|
        if ab.pitcher == @pid
          results << ab
        end
      end
      results
    end


    # Returns an array of pitches thrown by this pitcher during this game
    def get_pitches
      @pitches = []
      ab = get_vs_ab
      ab.each do |ab|
        @pitches << ab.pitches
      end
      @pitches.flatten!
    end


    def set_pitch_stats
      @b, @s, @x, @max_speed, @min_speed = 0, 0, 0, 0, 200
      pitches = get_pitches
      pitches.each do |pitch|
        case pitch.type
        when 'B'
          @b += 1
        when 'S'
          @s += 1
        when 'X'
          @x += 1
        end
        if pitch.start_speed.to_f > @max_speed
          @max_speed = pitch.start_speed.to_f
        end
        if pitch.start_speed.to_f < @min_speed
          @min_speed = pitch.start_speed.to_f
        end
      end
    end


    def pitch_count
      get_pitches.length
    end


    def get_game
      if !@game
        @game = Game.fetch(@gid)
      end
      @game
    end


    def convert_out_to_inn(outs)
      num_out = outs.to_i
      part = num_out % 3
      return (num_out/3).to_s + '.' + part.to_s
    end

  end
end