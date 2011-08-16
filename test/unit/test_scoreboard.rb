require 'test_helper'

class TestScoreboard < MiniTest::Unit::TestCase

  def test_fetch
    Gameday::GamedayFetcher.expects(:fetch_scoreboard_json).returns Fixture.local('scoreboard.json')
    sb = Gameday::Scoreboard.fetch 1,2,3

    assert_equal 12, sb.games.size
    assert sb.games.first.is_a?(Gameday::Game)
  end

end
