module Gameday
  class GamedayUrlBuilder
    def self.build_game_base_url(gid)
      gid_info = GamedayUtil.parse_gameday_id('gid_' + gid)
      y, m, d = gid_info['year'], gid_info['month'], gid_info['day']

      "#{build_day_url(y, m, d)}/gid_#{gid}"
    end


    def self.build_eventlog_url(year, month, day, gid)
      "#{game_url(year, month, day, gid)}/eventLog.xml"
    end


    def self.build_epg_url(year, month, day)
      "#{build_day_url(year, month, day)}/epg.xml"
    end


    def self.build_scoreboard_url(year, month, day)
      "#{build_day_url(year, month, day)}/master_scoreboard.xml"
    end


    def self.build_scoreboard_json_url(year, month, day)
      "#{build_day_url(year, month, day)}/master_scoreboard.json"
    end


    def self.build_day_highlights_url(year, month, day)
      "#{build_day_url(year, month, day)}/media/highlights.xml"
    end


    def self.build_boxscore_url(year, month, day, gid)
      "#{game_url(year, month, day, gid)}/boxscore.xml"
    end


    def self.build_game_url(year, month, day, gid)
      "#{game_url(year, month, day, gid)}/game.xml"
    end


    def self.build_game_events_url(year, month, day, gid)
      "#{game_url(year, month, day, gid)}/game_events.xml"
    end


    def self.build_gamecenter_url(year, month, day, gid)
      "#{game_url(year, month, day, gid)}/gamecenter.xml"
    end


    def self.build_linescore_url(year, month, day, gid)
      "#{game_url(year, month, day, gid)}/linescore.xml"
    end


    def self.build_linescore_json_url(year, month, day, gid)
      "#{game_url(year, month, day, gid)}/linescore.json"
    end


    def self.build_players_url(year, month, day, gid)
      "#{game_url(year, month, day, gid)}/players.xml"
    end


    def self.build_batter_url(year, month, day, gid, pid)
      "#{game_url(year, month, day, gid)}/batters/#{pid}.xml"
    end


    def self.build_pitcher_url(year, month, day, gid, pid)
      "#{game_url(year, month, day, gid)}/pitchers/#{pid}.xml"
    end


    def self.build_inningx_url(year, month, day, gid, inning_num)
      "#{game_url(year, month, day, gid)}/inning/inning_#{inning_num}.xml"
    end


    def self.build_inning_scores_url(year, month, day, gid)
      "#{game_url(year, month, day, gid)}/inning/inning_Scores.xml"
    end


    def self.build_inning_hit_url(year, month, day, gid)
      "#{game_url(year, month, day, gid)}/inning/inning_hit.xml"
    end


    def self.build_day_url(year, month, day)
      set_date_vars(year, month, day)
      "#{Gameday::GD2_MLB_BASE}/mlb/year_#{@@year}/month_#{@@month}/day_#{@@day}"
    end


    private

    def self.game_url year, month, day, gid
      "#{build_day_url(year, month, day)}/gid_#{gid}"
    end

    def self.set_date_vars(year, month, day)
      @@year = GamedayUtil.convert_digit_to_string(year.to_i)
      @@month = GamedayUtil.convert_digit_to_string(month.to_i)
      if day
        @@day = GamedayUtil.convert_digit_to_string(day.to_i)
      end
    end
  end
end
