require 'test_helper'

class TestGamedayFetcher < MiniTest::Unit::TestCase


  def setup

  end


  def test_fetch_bench
    mock_http do
      result = Gameday::GamedayFetcher.fetch_bench(GAME_ID)
      assert result
      assert result.include?('<?xml version="1.0" encoding="UTF-8" standalone="yes"?>')
    end
  end


  def test_fetch_bench_returning_404
    mock_http do
      result = Gameday::GamedayFetcher.fetch_bench('2010_04_05_nyamlb_bosmlb_1')
      assert_nil result
    end
  end


  def test_fetch_bencho
    mock_http do
      result = Gameday::GamedayFetcher.fetch_bencho(GAME_ID)
      assert result
      assert result.include?('Copyright 2009 MLB Advanced Media, L.P.  Use of any content on this page')
    end
  end


  def test_fetch_boxscore
    mock_http do
      result = Gameday::GamedayFetcher.fetch_boxscore(GAME_ID)
      assert result
      assert result.include?('Copyright 2009 MLB Advanced Media, L.P.  Use of any content on this page')
    end
  end


  def test_fetch_emailsource
    mock_http do
      result = Gameday::GamedayFetcher.fetch_emailsource(GAME_ID)
      assert result
      assert result.include?('Copyright 2009 MLB Advanced Media, L.P.  Use of any content on this page')
    end
  end


  def test_fetch_eventlog
    mock_http do
      result = Gameday::GamedayFetcher.fetch_eventlog(GAME_ID)
      assert result
      assert result.include?('Copyright 2009 MLB Advanced Media, L.P.  Use of any content on this page')
    end
  end


  def test_fetch_game_xml
    mock_http do
      result = Gameday::GamedayFetcher.fetch_game_xml(GAME_ID)
      assert result
      assert result.include?('Copyright 2009 MLB Advanced Media, L.P.  Use of any content on this page')
      assert result.include?('<game type="R" local_game_time="13:10" gameday_sw="E">')
    end
  end


  def test_fetch_gamecenter_xml
    mock_http do
      result = Gameday::GamedayFetcher.fetch_gamecenter_xml(GAME_ID)
      assert result
      assert result.include?('<game status="F" id="2009_09_20_detmlb_minmlb_1" start_time="2:10" ampm="pm" time_zone="ET"')
    end
  end


  def test_fetch_gamedaysyn
    mock_http do
      result = Gameday::GamedayFetcher.fetch_gamedaysyn(GAME_ID)
      assert result
      assert result.include?('Copyright 2009 MLB Advanced Media, L.P.  Use of any content on this page')
    end
  end


  def test_fetch_linescore
    mock_http do
      result = Gameday::GamedayFetcher.fetch_linescore(GAME_ID)
      assert result
      assert result.include?('<?xml version="1.0" encoding="UTF-8"?>')
    end
  end


  def test_fetch_miniscoreboard
    mock_http do
      result = Gameday::GamedayFetcher.fetch_miniscoreboard(GAME_ID)
      assert result
      assert result.include?('Copyright 2009 MLB Advanced Media, L.P.  Use of any content on this page')
    end
  end


  def test_fetch_players
    mock_http do
      result = Gameday::GamedayFetcher.fetch_players(GAME_ID)
      assert result
      assert result.include?('Copyright 2009 MLB Advanced Media, L.P.  Use of any content on this page')
    end
  end


  def test_fetch_plays
    mock_http do
      result = Gameday::GamedayFetcher.fetch_plays(GAME_ID)
      assert result
      assert result.include?('Copyright 2009 MLB Advanced Media, L.P.  Use of any content on this page')
    end
  end


  def test_fetch_scoreboard
    mock_http do
      result = Gameday::GamedayFetcher.fetch_scoreboard('2009', '9', '20')
      assert result
      assert result.include?('<?xml version="1.0" encoding="UTF-8"?>')
    end
  end


  def test_fetch_batter
    mock_http do
      result = Gameday::GamedayFetcher.fetch_batter(GAME_ID, '276346')
      assert result
      assert result.include?('Copyright 2009 MLB Advanced Media, L.P.  Use of any content on this page')
      assert result.include?('first_name="Brandon" last_name="Inge"')
    end
  end


  def test_fetch_pitcher
    mock_http do
      result = Gameday::GamedayFetcher.fetch_pitcher(GAME_ID, '150144')
      assert result
      assert result.include?('Copyright 2009 MLB Advanced Media, L.P.  Use of any content on this page')
      assert result.include?('first_name="Bobby" last_name="Seay"')
    end
  end


  def test_fetch_inningx
    mock_http do
      result = Gameday::GamedayFetcher.fetch_inningx(GAME_ID, 3)
      assert result
      assert result.include?('Copyright 2009 MLB Advanced Media, L.P.  Use of any content on this page')
      assert result.include?('<inning num="3" away_team="det"')
    end
  end


  def test_fetch_inning_scores
    mock_http do
      result = Gameday::GamedayFetcher.fetch_inning_scores(GAME_ID)
      assert result
      assert result.include?('Copyright 2009 MLB Advanced Media, L.P.  Use of any content on this page')
      assert result.include?('Jason Kubel grounds out, second baseman Placido Polanco to first')
    end
  end


  def test_fetch_inning_hit
    mock_http do
      result = Gameday::GamedayFetcher.fetch_inning_hit(GAME_ID)
      assert result
      assert result.include?('Copyright 2009 MLB Advanced Media, L.P.  Use of any content on this page')
      assert result.include?('<hip des="Error" x="71.29" y="122.49" batter="135784"')
    end
  end


  def test_fetch_games_page
    mock_http do
      result = Gameday::GamedayFetcher.fetch_games_page('2009', '9', '20')
      assert result
      assert result.include?('<h1>Index of /components/game/mlb/year_2009/month_09/day_20</h1>')
    end
  end


  def test_fetch_batters_page
    mock_http do
      result = Gameday::GamedayFetcher.fetch_batters_page(GAME_ID)
      assert result
      assert result.include?('<h1>Index of /components/game/mlb/year_2009/month_09/day_20/')
      assert result.include?('<li><a href="111851.xml"> 111851.xml</a></li>')
    end
  end


  def test_fetch_pitchers_page
    mock_http do
      result = Gameday::GamedayFetcher.fetch_pitchers_page(GAME_ID)
      assert result
      assert result.include?('<h1>Index of /components/game/mlb/year_2009/month_09/day_20/')
      assert result.include?('<li><a href="150274.xml"> 150274.xml</a></li>')
    end
  end


  def test_fetch_media_highlights
    mock_http do
      result = Gameday::GamedayFetcher.fetch_media_highlights(GAME_ID)
      assert result
      assert result.include?('<media type="video" date="2009-09-20T15:30:27-0400" id="6751897" v="3">')
    end
  end


  def test_fetch_media_mobile
    mock_http do
      result = Gameday::GamedayFetcher.fetch_media_mobile(GAME_ID)
      assert result
      assert result.include?('<media id="6748565" date="2009-09-20T14:30:24-0400" type="video" top-play="true">')
    end
  end


  def test_fetch_onbase_linescore
    mock_http do
      result = Gameday::GamedayFetcher.fetch_onbase_linescore(GAME_ID)
      assert result

      assert result.include?('away_inning_runs')
    end
  end


  def test_fetch_onbase_plays
    mock_http do
      result = Gameday::GamedayFetcher.fetch_onbase_plays(GAME_ID)
      assert result
      assert result.include?('<who p="407845" era="3.82" b="346857" avg=".227" b1="445196" b2="" b3=""/>')
    end
  end


  def test_fetch_notifications_inning
    mock_http do
      result = Gameday::GamedayFetcher.fetch_notifications_inning(GAME_ID, 3)
      assert result
      assert result.include?('<notification inning="3" top="N" ab="25" pitch="0" seq="1" away_team_runs="0"')
    end
  end


  def test_fetch_notifications_full
    mock_http do
      result = Gameday::GamedayFetcher.fetch_notifications_full(GAME_ID)
      assert result
      assert result.include?('<notifications modified_date="2009-09-28T15:50:23Z">')
    end
  end



end