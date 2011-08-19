module Gameday

  # This class contains data representing a linescore for a single game.
  class LineScore < Resource

    attr_accessor :xml_doc
    attr_accessor :innings

    attr_accessor :ampm, :aw_lg_ampm, :away_ampm, :away_code, :away_division
    attr_accessor :away_file_code, :away_games_back, :away_league_id, :away_loss
    attr_accessor :away_name_abbrev, :away_preview_link, :away_recap_link
    attr_accessor :away_sport_code, :away_team_city, :away_team_errors
    attr_accessor :away_team_hits, :away_team_id, :away_team_name
    attr_accessor :away_team_runs, :away_time, :away_time_zone, :away_win, :day
    attr_accessor :game_media, :game_pk, :game_type, :gameday_link, :gameday_sw
    attr_accessor :hm_lg_ampm, :home_ampm, :home_code, :home_division
    attr_accessor :home_file_code, :home_games_back, :home_games_back_wildcard
    attr_accessor :home_league_id, :home_loss, :home_name_abbrev
    attr_accessor :home_preview_link, :home_recap_link, :home_sport_code
    attr_accessor :home_team_city, :home_team_errors, :home_team_hits
    attr_accessor :home_team_id, :home_team_name, :home_team_runs, :home_time
    attr_accessor :home_time_zone, :home_win, :id, :ind, :inning, :league
    attr_accessor :linescore, :losing_pitcher, :outs, :photos_link, :preview
    attr_accessor :save_pitcher, :scheduled_innings, :status, :time, :time_aw_lg
    attr_accessor :time_hm_lg, :time_zone, :top_inning, :tv_station
    attr_accessor :tz_aw_lg_gen, :tz_hm_lg_gen, :venue, :venue_id
    attr_accessor :venue_w_chan_loc, :winning_pitcher, :wrapup_link

    def self.fetch gid
      json = GamedayFetcher.fetch_linescore_json gid
      hash = JSON.parse json

      new_from_hash hash['data']['game']
    end

    # Initialize this instance from an XML element containing linescore data.
    def init(element)
      init_from_xml element
      # Set score by innings
      self.innings = get_innings element
    end

    private

    def get_innings xml_doc
      inns = []
      xml_doc.elements.each("inning_line_score") do |element|
        inns.push([element.attributes["away"], element.attributes["home"]])
      end
      inns
    end

  end
end
