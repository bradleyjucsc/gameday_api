
module Gameday
  # This class represents a single pitch in an MLB baseball game.
  # Most of the attributes represent the physics of the pitch thrown.
  #
  class Pitch < Resource

    attr_accessor :gid, :ab_num, :pitcher_id, :batter_id
    attr_accessor :des, :pitch_id, :type, :x, :y, :sv_id, :start_speed, :end_speed
    attr_accessor :sz_top, :sz_bot, :pfx_x, :pfx_z, :px, :pz, :x0, :y0, :z0, :vx0, :vy0, :vz0
    attr_accessor :ax, :ay, :az, :break_y, :break_angle, :break_length, :pitch_type, :type_confidence
    attr_accessor :spin_dir, :spin_rate, :on_1b, :on_2b, :on_3b

    PITCHES = {
      'FS' => 'Splitter',
      'SL' => 'Slider',
      'FF' => 'Fastball', # 4 seam
      'FT' => 'Fastball', # 2 seam
      'SI' => 'Sinker',
      'CH' => 'Change',
      'FA' => 'Fastball',
      'CU' => 'Curve',
      'FC' => 'Cutter',
      'KN' => 'Knuckle',
      'KC' => 'Knuckle Curve',
    }

    def self.new_from_xml element
      pitch = super element
      pitch.pitch_id = element.attributes["id"]

      pitch
    end

    def self.get_pitch_name(code)
      PITCHES[code] || code
    end

  end

end
