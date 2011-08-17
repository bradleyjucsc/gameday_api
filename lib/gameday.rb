require 'rubygems'
require 'net/http'
require 'hpricot'
require 'erb'
require 'json'

require 'gameday/resource'
require 'gameday/gameday_fetcher'
require 'gameday/gameday_url_builder'
require 'gameday/gameday_util'
require 'gameday/helpers'

require 'gameday/resources/at_bat'
require 'gameday/resources/batting_appearance'
require 'gameday/resources/box_score'
require 'gameday/resources/coach'
require 'gameday/resources/event'
require 'gameday/resources/event_log'
require 'gameday/resources/game'
require 'gameday/resources/game_status'
require 'gameday/resources/hip'
require 'gameday/resources/hitchart'
require 'gameday/resources/inning'
require 'gameday/resources/line_score'
require 'gameday/resources/media'
require 'gameday/resources/media_highlight'
require 'gameday/resources/media_mobile'
require 'gameday/resources/pitch'
require 'gameday/resources/pitching_appearance'
require 'gameday/resources/player'
require 'gameday/resources/players'
require 'gameday/resources/roster'
require 'gameday/resources/schedule'
require 'gameday/resources/schedule_game'
require 'gameday/resources/scoreboard'
require 'gameday/resources/team'

# Subclasses of gameday/player
require 'gameday/resources/batter'
require 'gameday/resources/pitcher'

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