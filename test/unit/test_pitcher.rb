require 'test_helper'

class TestPitcher < MiniTest::Unit::TestCase


  def test_load_from_id
    mock_http CASSETTE do
      pitcher = Gameday::Pitcher.new
      pitcher.load_from_id('2010_04_13_kcamlb_detmlb_1','453286')
      assert_equal 'det', pitcher.team_abbrev
      assert_equal 'Max', pitcher.first_name
      assert_equal 'Scherzer', pitcher.last_name
      assert_equal '.256', pitcher.opponent_season.avg
      assert_equal '.249', pitcher.opponent_career.avg
    end
  end


  def test_get_vs_ab
    mock_http CASSETTE do
      pitcher = Gameday::Pitcher.new
      pitcher.load_from_id('2010_04_13_kcamlb_detmlb_1','425883')
      ab = pitcher.get_vs_ab
      assert_equal 27, ab.length

      pitcher = Gameday::Pitcher.new
      pitcher.load_from_id('2010_04_13_kcamlb_detmlb_1','407878')
      ab = pitcher.get_vs_ab
      assert_equal 3, ab.length

      pitcher = Gameday::Pitcher.new
      pitcher.load_from_id('2010_04_13_kcamlb_detmlb_1','150144')
      ab = pitcher.get_vs_ab
      assert_equal 0, ab.length
    end
  end


  def test_get_pitches
    mock_http CASSETTE do
      pitcher = Gameday::Pitcher.new
      pitcher.load_from_id('2010_04_13_kcamlb_detmlb_1','425883')
      pitches = pitcher.get_pitches
      assert_equal 104, pitches.length

      pitcher = Gameday::Pitcher.new
      pitcher.load_from_id('2010_04_13_kcamlb_detmlb_1','407878')
      pitches = pitcher.get_pitches
      assert_equal 12, pitches.length

      pitcher = Gameday::Pitcher.new
      pitcher.load_from_id('2010_04_13_kcamlb_detmlb_1','150144')
      pitches = pitcher.get_pitches
      assert_equal 0, pitches.length
    end
  end


  def test_get_all_ids_for_game
    mock_http CASSETTE do
      ids = Gameday::Pitcher.get_all_ids_for_game(GAME_ID)
      assert ids
      assert_equal 41, ids.length
      assert_equal "118158", ids[0]
      assert_equal "132220", ids[1]
      assert_equal "545363", ids[39]
      assert_equal "547820", ids[40]
    end
  end

end