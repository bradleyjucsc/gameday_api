require 'test_helper'

class TestBatter < MiniTest::Unit::TestCase
  
  
  def test_load_from_id
    mock_http CASSETTE do
      batter = Gameday::Batter.new
      batter.load_from_id(GAME_ID,'136722')
      assert_equal 'det', batter.team_abbrev
      assert_equal 'Carlos', batter.first_name
      assert_equal 'Guillen', batter.last_name
      assert_equal '.238', batter.season_stats.avg
      assert_equal '.287', batter.career_stats.avg
      assert_equal '.171', batter.month_stats.avg
    end
  end
  
  
  def test_get_all_ids_for_game
    mock_http CASSETTE do
      batters = Gameday::Batter.get_all_ids_for_game(GAME_ID)
      assert batters
      assert_equal 87, batters.length
      assert_equal "111851", batters[0]
      assert_equal "118158", batters[1]
      assert_equal "545363", batters[85]
      assert_equal "547820", batters[86]
    end
  end
  
  
  def test_get_all_ids_for_game_non_existing_page
    mock_http CASSETTE do
      batters = Gameday::Batter.get_all_ids_for_game('2010_04_05_nyamlb_bosmlb_1')
      assert_equal 0, batters.length
    end
  end

end