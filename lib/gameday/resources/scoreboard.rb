module Gameday
  ##
  # A scoreboard for a given day contains an array of Game objects which have
  # basic info about each game.  Who's playing, the time, the venue, etc.

  class Scoreboard < Resource

    attr_accessor :games  # An array of Game objects representing all of the games played on this date
    attr_accessor :year, :month, :day

    ##
    # Fetches the json scoreboard and populates game objects
    def self.fetch year, month, day
      json = GamedayFetcher.fetch_scoreboard_json year, month, day

      hash = JSON.parse json
      interesting_hash = hash['data']['games']

      sb = new_from_hash interesting_hash
      sb.games = interesting_hash['game'].map do |g_hash|
        Game.new_from_hash g_hash
      end

      sb
    end

    def load_for_date(year, month, day)
      @games = []
      @year = year
      @month = month
      @day = day
      @xml_data = GamedayFetcher.fetch_scoreboard(year, month, day)
      @xml_doc = REXML::Document.new(@xml_data)

      @xml_doc.elements.each("games/game") { |element|
        game = Game.fetch(element.attributes['gameday'])
        game.load_from_scoreboard(element)
        @games << game
      }
    end

  end
end
