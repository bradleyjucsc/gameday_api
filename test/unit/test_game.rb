require 'test_helper'

class TestGame < MiniTest::Unit::TestCase

  def test_new_from_hash_set_id_correctly
    assert_equal 'a_b_c', Gameday::Game.new_from_hash('id' => 'a/b-c').gid
  end

  def test_initialize
    gid = '2008_04_07_atlmlb_colmlb_1'

    mock_http CASSETTE do
      game = Gameday::Game.fetch(gid)
      assert game
      assert_equal '2008_04_07_atlmlb_colmlb_1', game.gid
      assert_equal 'col', game.home_team_abbrev
      assert_equal 'atl', game.visit_team_abbrev
      assert_equal 'atl', game.visiting_team.abrev
      assert_equal 'col', game.home_team.abrev
      assert_equal '2008', game.year
      assert_equal '04', game.month
      assert_equal '07', game.day
      assert_equal '1', game.game_number
      assert_equal 'Colorado', game.home_team_name
      assert_equal 'Atlanta', game.visit_team_name
    end
  end


  def test_find_by_date
    mock_http CASSETTE do
      games = Gameday::Game.find_by_date('2009', '8', '20')

      assert games
      assert_equal 12, games.length
    end
  end


  def test_find_by_month
    Gameday::Game.expects(:find_by_date).times(30).returns(['fake_game'])
    games = Gameday::Game.find_by_month('2009', '9')
    assert games
    assert_equal 30, games.length
  end


  def test_get_rosters

    mock_http CASSETTE do
      game = Gameday::Game.fetch(GAME_ID)
      rosters = game.get_rosters
      assert_equal 'Detroit Tigers', rosters[0].team_name
      assert_equal 'Minnesota Twins', rosters[1].team_name
      assert_equal 34, rosters[0].players.length
      assert_equal 31, rosters[1].players.length
    end
  end


  def test_get_eventlog
    mock_http CASSETTE do
      game = Gameday::Game.fetch(GAME_ID)
      eventlog = game.get_eventlog
      assert eventlog
      assert_equal 'Minnesota', eventlog.home_team
      assert_equal 'Detroit', eventlog.away_team
    end
  end


  def test_get_boxscore
    mock_http CASSETTE do
      game = Gameday::Game.fetch(GAME_ID)
      bs = game.get_boxscore
      assert bs
      assert_equal 'Detroit Tigers', bs.away_fname
      assert_equal 'Minnesota Twins', bs.home_fname
    end
  end


  def test_print_linescocre
    mock_http CASSETTE do
      game = Gameday::Game.fetch(GAME_ID)
      ls = game.print_linescore
      assert ls
      assert ls.length > 0
    end
  end


  def test_get_starting_pitchers
    mock_http CASSETTE do
      game = Gameday::Game.fetch(GAME_ID)
      sp = game.get_starting_pitchers
      assert_equal 2, sp.length
      assert_equal 'Robertson, N', sp[0].pitcher_name
      assert_equal 'Baker, S', sp[1].pitcher_name
    end
  end


  def test_get_closing_pitchers
    mock_http CASSETTE do
      game = Gameday::Game.fetch(GAME_ID)
      cp = game.get_closing_pitchers
      assert_equal 2, cp.length
      assert_equal 'Rodney', cp[0].pitcher_name
      assert_equal 'Keppel', cp[1].pitcher_name
    end
  end


  def test_get_pitchers
    mock_http CASSETTE do
      game = Gameday::Game.fetch(GAME_ID)
      pitchers = game.get_pitchers('home')
      assert_equal 6, pitchers.length
      pitchers = game.get_pitchers('away')
      assert_equal 4, pitchers.length
    end
  end


  def test_get_pitches
    mock_http CASSETTE do
      game = Gameday::Game.fetch GAME_ID
      pitches = game.get_pitches('407845')
      assert_equal 16, pitches.length
      assert pitches[0].start_speed = '95.7'
    end
  end


  def test_get_batters
    mock_http CASSETTE do
      game = Gameday::Game.fetch(GAME_ID)
      batters = game.get_batters('home')
      assert_equal 16, batters.length
      assert_equal 'Span', batters[0].batter_name
      batters = game.get_batters('away')
      assert_equal 16, batters.length
      assert_equal 'Granderson', batters[0].batter_name
    end
  end


  def test_get_lineups
    mock_http CASSETTE do
      game = Gameday::Game.fetch(GAME_ID)
      lineups = game.get_lineups
      assert_equal 2, lineups.length
      assert_equal 16, lineups[0].length
      assert_equal 16, lineups[1].length
      assert_equal 'Granderson', lineups[0][0].batter_name
      assert_equal 'Span', lineups[1][0].batter_name
    end
  end


  def test_get_pitching
    mock_http CASSETTE do
      game = Gameday::Game.fetch(GAME_ID)
      pitching = game.get_pitching
      assert_equal 2, pitching.length
      assert_equal 4, pitching[0].length
      assert_equal 6, pitching[1].length
    end
  end


  def test_get_winner
    mock_http CASSETTE do
      game = Gameday::Game.fetch(GAME_ID)
      winner = game.get_winner
      assert_equal 'det', winner
      game = Gameday::Game.fetch('2009_09_20_nyamlb_seamlb_1')
      winner = game.get_winner
      assert_equal 'sea', winner
    end
  end


  def test_get_score
    mock_http CASSETTE do
      game = Gameday::Game.fetch(GAME_ID)
      score = game.get_score
      assert_equal '6', score[0]
      assert_equal '2', score[1]
    end
  end


  def test_get_attendance
    mock_http CASSETTE do
      game = Gameday::Game.fetch(GAME_ID)
      attend = game.get_attendance
      assert_equal '36,335', attend

      game = Gameday::Game.fetch('2010_04_10_bosmlb_kcamlb_1')
      attend = game.get_attendance
      assert_equal '37,505', attend
    end
  end


  def test_get_media
    mock_http CASSETTE do
      game = Gameday::Game.fetch(GAME_ID)
      media = game.get_media
      assert media
      assert media.highlights
      assert media.mobile
    end
  end


  def test_get_innings
    mock_http CASSETTE do
      game = Gameday::Game.fetch(GAME_ID)
      innings = game.get_innings
      assert_equal 9, innings.length

      game = Gameday::Game.fetch('2009_05_02_kcamlb_minmlb_1')
      innings = game.get_innings
      assert_equal 11, innings.length
    end
  end


  def test_get_atbats
    game = nil
    mock_http CASSETTE do
      game = Gameday::Game.fetch(GAME_ID)
    end

    mock_http CASSETTE do
      atbats = game.get_atbats
      assert atbats
      assert_equal 81, atbats.length
    end
  end


  def test_get_hitchart
    mock_http CASSETTE do
      game = Gameday::Game.fetch(GAME_ID)
      hitchart = game.get_hitchart
      assert hitchart
      assert_equal 57, hitchart.hips.length
    end
  end


  def test_get_num_innings
    mock_http CASSETTE do
      game = Gameday::Game.fetch('2008_04_07_atlmlb_colmlb_1')
      assert_equal 9, game.get_num_innings

      game = Gameday::Game.fetch('2009_05_02_kcamlb_minmlb_1')
      assert_equal 11, game.get_num_innings
    end
  end


end