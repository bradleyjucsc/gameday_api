module Gameday
  # This class represents a single MLB game
  class Game < Resource

    attr_accessor :gid, :original_gid, :home_team_name, :home_team_abbrev, :visit_team_name, :visit_team_abbrev,
                  :year, :month, :day, :game_number, :visiting_team, :home_team
    attr_accessor :boxscore, :rosters, :eventlog, :media, :date

    attr_accessor :innings #array of Inning objects, from innings files

    attr_accessor :players # data from the players.xml file

    # additional attributes from master_scoreboard.xml
    attr_accessor :scoreboard_game_id, :ampm, :venue, :game_pk, :time, :time_zone, :game_type
    attr_accessor :away_name_abbrev, :home_name_abbrev, :away_code, :away_file_code, :away_team_id
    attr_accessor :away_team_city, :away_team_name, :away_division
    attr_accessor :home_code, :home_file_code, :home_team_id, :home_team_city, :home_team_name, :home_division
    attr_accessor :day, :gameday_sw, :away_games_back, :home_games_back, :away_games_back_wildcard, :home_games_back_wildcard
    attr_accessor :venue_w_chan_loc, :gameday, :away_win, :away_loss, :home_win, :home_loss, :league

    attr_accessor :status  # An instance of GameStatus object
    attr_accessor :homeruns # an array of players with homeruns in the game
    attr_accessor :winning_pitcher, :losing_pitcher, :save_pitcher  # Instances of Player object
    attr_accessor :away_innings, :home_innings  # An arry of one element for each inning, the element is the home or away score
    attr_accessor :home_hits, :away_hits, :home_errors, :away_errors, :home_runs, :away_runs

    def self.new_from_hash hash
      g = super
      g.gid = hash['id'].gsub('/', '_').gsub('-', '_') if hash['id']
      g.original_gid = hash['id']

      g
    end


    def self.fetch(gid)
      g = Game.new
      g.innings = []
      if gid
        g.gid = gid
        xml_data = GamedayFetcher.fetch_game_xml(gid)
        if xml_data && xml_data.size > 0
          xml_doc = REXML::Document.new(xml_data)
          g.game_type = xml_doc.root.attributes["type"]
          g.time = xml_doc.root.attributes["local_game_time"]
          info = Helpers.parse_gameday_id('gid_'+gid)
          g.home_team_abbrev = info["home_team_abbrev"]
          g.visit_team_abbrev = info["visiting_team_abbrev"]
          g.visiting_team = Team.new(g.visit_team_abbrev )
          g.home_team = Team.new(g.home_team_abbrev )
          g.year = info["year"]
          g.month = info["month"]
          g.day = info["day"]
          g.game_number = info["game_number"]
          if Team.teams[g.home_team_abbrev]
            g.home_team_name = Team.teams[g.home_team_abbrev][0]
          else
            g.home_team_name = g.home_team_abbrev
          end
          if Team.teams[g.visit_team_abbrev]
            g.visit_team_name = Team.teams[g.visit_team_abbrev][0]
          else
            g.visit_team_name = g.visit_team_abbrev
          end
        else
          raise ArgumentError, "Could not find game.xml"
        end
      end
      g
    end


    # Setup a Game object from data read from the  master_scoreboard.xml file
    def self.load_from_scoreboard element
      g = new_from_xml

      g.away_innings = []
      g.home_innings = []

      g.set_status(element)
      g.set_innings(element)
      g.set_totals(element)
      g.set_pitchers(element)
      g.set_homeruns(element)
    end


    # Sets the game status from data in the master_scoreboard.xml file
    def set_status(element)
      element.elements.each("status") { |status|
        @status = GameStatus.new
        @status.status = status.attributes['status']
        @status.ind = status.attributes['ind']
        @status.reason = status.attributes['reason']
        @status.inning = status.attributes['inning']
        @status.top_inning = status.attributes['top_inning']
        @status.b = status.attributes['b']
        @status.s = status.attributes['s']
        @status.o = status.attributes['o']
      }
    end


    # Sets the away and home innings array containing scores by inning from data in the master_scoreboard.xml file
    def set_innings(element)
      element.elements.each("linescore/inning") { |element|
         @away_innings << element.attributes['away']
         @home_innings << element.attributes['home']
      }
    end


    # Sets the Runs/Hits/Errors totals from data in the master_scoreboard.xml file
    def set_totals(element)
      element.elements.each("linescore/r") { |runs|
         @away_runs = runs.attributes['away']
         @home_runs = runs.attributes['home']
      }
      element.elements.each("linescore/h") { |hits|
         @away_hits = hits.attributes['away']
         @home_hits = hits.attributes['home']
      }
      element.elements.each("linescore/e") { |errs|
         @away_errors = errs.attributes['away']
         @home_errors = errs.attributes['home']
      }
    end


    # Sets a list of players who had homeruns in this game from data in the master_scoreboard.xml file
    def set_homeruns(element)
      @homeruns = []
      element.elements.each("home_runs/player") do |hr|
        @homeruns << Player.new_from_xml(hr)
      end
    end


    # Sets the pitchers of record (win, lose, save) from data in the master_scoreboard.xml file
    def set_pitchers(element)
      element.elements.each("winning_pitcher") do |wp|
        @winning_pitcher = Player.new_from_xml wp
      end
      element.elements.each("losing_pitcher") do |lp|
        @losing_pitcher = Player.new_from_xml lp
      end
      element.elements.each("save_pitcher") do |sp|
        @save_pitcher = Player.new_from_xml sp
      end
    end


    def self.find_by_month(year, month)
      games = []
      start_date = Date.new(year.to_i, month.to_i) # first day of month
      end_date = (start_date >> 1)-1 # last day of month
      ((start_date)..(end_date)).each do |dt|
        games += find_by_date(year, month, dt.day.to_s)
      end
      games
    end


    # Returns an array of Game objects for each game for the specified day
    def self.find_by_date(year, month, day)
      begin
        games = []
        games_page = GamedayFetcher.fetch_games_page(year, month, day)

        if games_page
          @hp = Hpricot(games_page)
          a = @hp.at('ul')
          (a/"a").each do |link|
            # look at each link inside of a ul tag
            if link.inner_html.include?('gid')
              # if the link contains the text 'gid' then it is a listing of a game
              str = link.inner_html
              gid = str[5..str.length-2]
              begin
                game = Game.fetch(gid)
                games.push game
              rescue => e
                puts "Could not create game object for #{year}, #{month}, #{day} - #{gid}:\n#{e}"
              end
            end
          end
        else
          puts "Could not read games page for #{year}, #{month}, #{day}."
        end
        return games
      rescue
        puts "No games data found for #{year}, #{month}, #{day}."
      end
    end


    # Returns a 2 element array containing the home and visiting rosters for this game
    #    [0] array of all visitor players
    #    [1] array of all home players
    def get_rosters
      if !@rosters
        players = Players.new
        players.load_from_id(@gid)
        @rosters = players.rosters
      end
      @rosters
    end


    def get_eventlog
      if !@eventlog
        @eventlog = EventLog.new
        @eventlog.load_from_id(@gid)
      end
      @eventlog
    end


    # Returns a BoxScore object representing the boxscore for this game
    def get_boxscore
      if !@boxscore
        box = BoxScore.new
        box.load_from_id(self.gid)
        @boxscore = box
      end
      @boxscore
    end


    # Returns a string containing the linescore in the following printed format:
    #   Away 1 3 1
    #   Home 5 8 0
    def print_linescore
      bs = get_boxscore
      output = ''
      if bs.linescore
        output += self.visit_team_name + ' ' + bs.linescore.away_team_runs + ' ' + bs.linescore.away_team_hits + ' ' + bs.linescore.away_team_errors + "\n"
        output += self.home_team_name + ' ' + bs.linescore.home_team_runs + ' ' + bs.linescore.home_team_hits + ' ' + bs.linescore.home_team_errors
      else
        output += 'No linescore available for ' + @visit_team_name + ' vs. ' + @home_team_name
      end
      output
    end


    # Returns an array of the starting pitchers for the game
    #    [0] = visiting team pitcher
    #    [1] = home team pitcher
    def get_starting_pitchers
      results = []
      results << get_pitchers('away')[0]
      results << get_pitchers('home')[0]
    end


    # Returns an array of the closing pitchers for the game
    #    [0] = visiting team pitcher
    #    [1] = home team pitcher
    def get_closing_pitchers
      results = []
      away_pitchers = get_pitchers('away')
      home_pitchers = get_pitchers('home')
      results << away_pitchers[(away_pitchers.size) - 1]
      results << home_pitchers[(home_pitchers.size) -1]
    end


    # Returns an array of all pitchers for either the home team or the away team.
    # The values in the returned array are PitchingAppearance instances
    def get_pitchers(home_or_away)
      if self.gid
        bs = get_boxscore
        if home_or_away == 'away'
          bs.pitchers[0]
        else
          bs.pitchers[1]
        end
      else
        puts "No data for input specified"
      end
    end


    # Returns an array of pitches from this game for the pitcher identified by pid
    def get_pitches(pid)
      results = []
      atbats = get_atbats
      atbats.each do |ab|
        if ab.pitcher == pid
          results << ab.pitches
        end
      end
      results.flatten
    end


    # Returns an array of either home or away batters for this game
    # home_or_away must be a string with value 'home' or 'away'
    # The values in the returned array are BattingAppearance instances
    def get_batters(home_or_away)
      if self.gid
        bs = get_boxscore
        if home_or_away == 'away'
          bs.batters[0]
        else
          bs.batters[1]
        end
      else
        puts "No data for input specified"
      end
    end


    # Returns the starting lineups for this game in an array with 2 elements
    # results[0] = visitors
    # results[1] = home
    def get_lineups
      results = []
      results << get_batters('away')
      results << get_batters('home')
    end


    # Returns the pitchers for this game in an array with 2 elements
    # results[0] = visitors
    # results[1] = home
    def get_pitching
      results = []
      results << get_pitchers('away')
      results << get_pitchers('home')
    end


    # Returns the team abreviation of the winning team
    def get_winner
      ls = get_boxscore.linescore
      if ls.home_team_runs > ls.away_team_runs
        return home_team_abbrev
      else
        return visit_team_abbrev
      end
    end


    # Returns a 2 element array holding the game score
    #    [0] visiting team runs
    #    [1] home team runs
    def get_score
      results = []
      ls = get_boxscore.linescore
      results << ls.away_team_runs
      results << ls.home_team_runs
      results
    end


    # Returns a string holding the game attendance value
    def get_attendance
      game_info = get_boxscore.game_info
      # parse game_info to get attendance
      game_info[game_info.length-12..game_info.length-7]
    end


    def get_media
      if !@media
        @media = Media.fetch_by @gid
      end
      @media
    end


    # Returns an array of Inning objects that represent each inning of the game
    def get_innings
      if @innings.length == 0
        @innings = (1..get_num_innings).map do |inn|
                     Inning.fetch_by @gid, inn
                   end
      end

      @innings
    end


    # Returns an array of AtBat objects that represent each atbat of the game
    def get_atbats
      atbats = []
      innings = get_innings
      innings.each do |inning|
        inning.top_atbats.each do |atbat|
          atbats << atbat
        end
        inning.bottom_atbats.each do |atbat|
          atbats << atbat
        end
      end
      atbats
    end


    def get_hitchart
      if !@hitchart
        @hitchart = Hitchart.fetch_by @gid
      end
      @hitchart
    end


    # Returns the number of innings for this game
    def get_num_innings
      bs = get_boxscore
      if bs.linescore
        return get_boxscore.linescore.innings.length
      else
        return 0
      end
    end


    # Returns a hash of umpires for this game
    #
    #   { 'hp' => 'john doe',
    #     '1b' => 'paul jones',
    #     '2b' => 'mike james',
    #     '3b' => 'pete myers' }
    #
    def get_umpires
      if !@players
        @players = Players.new
        @players.load_from_id(@gid)
      end
      @players.umpires
    end


    def get_date
      bs = get_boxscore
      bs.date
    end


    def get_temp
      bs = get_boxscore
      bs.temp
    end


    def get_wind_speed
      bs = get_boxscore
      bs.wind_speed
    end


    def get_wind_dir
      bs = get_boxscore
      bs.wind_dir
    end


    def get_home_runs
      bs = get_boxscore
      bs.home_runs
    end


    def get_away_runs
      bs = get_boxscore
      bs.away_runs
    end


  end

end