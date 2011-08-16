require 'test_helper'

class TestRoster < Test::Unit::TestCase

  CASSETTE = 'roster'

  def test_find_player_by_last_name
    mock_http CASSETTE do
      game = Gameday::Game.fetch(GAME_ID)
      rosters = game.get_rosters
      player = rosters[0].find_player_by_last_name('Verlander')
      assert_not_nil player
      assert_equal 'Justin', player.first
      assert_equal 'Verlander', player.last
    end
  end


  def test_find_player_by_id
    mock_http CASSETTE do
      game = Gameday::Game.fetch(GAME_ID)
      rosters = game.get_rosters
      player = rosters[0].find_player_by_id('425146')
      assert_not_nil player
      assert_equal 'Nate', player.first
      assert_equal 'Robertson', player.last
    end
  end

end