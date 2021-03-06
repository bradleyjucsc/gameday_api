require 'test_helper'

class TestRoster < MiniTest::Unit::TestCase

  CASSETTE = 'roster'

  def test_find_player_by_last_name
    mock_http do
      game = Gameday::Game.fetch(GAME_ID)
      rosters = game.get_rosters
      player = rosters[0].find_player_by_last_name('Verlander')
      assert player
      assert_equal 'Justin', player.first
      assert_equal 'Verlander', player.last
    end
  end


  def test_find_player_by_id
    mock_http do
      game = Gameday::Game.fetch(GAME_ID)
      rosters = game.get_rosters
      player = rosters[0].find_player_by_id('425146')
      assert player
      assert_equal 'Nate', player.first
      assert_equal 'Robertson', player.last
    end
  end

end