require 'test_helper'

class TestInning < MiniTest::Unit::TestCase


  def test_load_from_id
    mock_http do
      inning = Gameday::Inning.fetch_by GAME_ID, 3
      assert_equal GAME_ID, inning.gid
      assert_equal '3', inning.num
      assert_equal 'det', inning.away_team
      assert_equal 'min', inning.home_team
      assert_equal 4, inning.top_atbats.length
      assert_equal 4, inning.bottom_atbats.length
      assert_equal 4, inning.top_atbats[0].pitches.length
      assert_equal 1, inning.top_atbats[1].pitches.length
      assert_equal 'Foul', inning.top_atbats[0].pitches[0].des
      assert_equal '151', inning.top_atbats[0].pitches[0].pitch_id
      assert_equal 'S', inning.top_atbats[0].pitches[0].type
      assert_equal '90.13', inning.top_atbats[0].pitches[0].x
    end
  end


end