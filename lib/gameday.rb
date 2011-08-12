require 'rubygems'
require 'net/http'
require 'hpricot'
require 'erb'
require 'json'

require 'gameday/resource'

require 'gameday/at_bat'
require 'gameday/batting_appearance'
require 'gameday/box_score'
require 'gameday/cache_fetcher'
require 'gameday/coach'
require 'gameday/data_downloader'
require 'gameday/db_importer'
require 'gameday/event'
require 'gameday/event_log'
require 'gameday/game'
require 'gameday/game_status'
require 'gameday/gameday_fetcher'
require 'gameday/gameday_parser'
require 'gameday/gameday_path_builder'
require 'gameday/gameday_url_builder'
require 'gameday/gameday_util'
require 'gameday/hip'
require 'gameday/hitchart'
require 'gameday/inning'
require 'gameday/line_score'
require 'gameday/media'
require 'gameday/media_highlight'
require 'gameday/media_mobile'
require 'gameday/pitch'
require 'gameday/pitchfx_db_manager'
require 'gameday/pitching_appearance'
require 'gameday/player'
require 'gameday/players'
require 'gameday/roster'
require 'gameday/schedule'
require 'gameday/schedule_game'
require 'gameday/scoreboard'
require 'gameday/team'

# Subclasses of gameday/player
require 'gameday/batter'
require 'gameday/pitcher'

module Gameday
  class Gameday

    # Change this to point to the server you are reading Gameday data from
    GD2_MLB_BASE = "http://gd2.mlb.com/components/game"
    
    
    def initialize
      super
    end
  
  
    # Returns an array of game id's for the given date
    def get_all_gids_for_date(year, month, day)
      begin 
        gids = []
        url = GamedayUtil.build_day_url(year, month, date)
        connection = GamedayUtil.get_connection(url)
        if connection
          @hp = Hpricot(connection) 
          a = @hp.at('ul')  
          (a/"a").each do |link|
            if link.inner_html.include?('gid')
              str = link.inner_html
              gids.push str[5..str.length-2]
            end
          end
        end
        connection.close
        return gids
      rescue
        puts "No games data found for #{year}, #{month}, #{day}."
      end
    end
  
  
    # Converts numbers to two character strings by prepending a '0' if number
    # is less than 10.
    def convert_to_two_digit_str(number)
      if number < 10
        return '0'+number.to_s
      else
        return number.to_s
      end
    end
  
  end
end