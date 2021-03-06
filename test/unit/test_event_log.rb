require 'test_helper'

class TestEventLog < MiniTest::Unit::TestCase


  def test_load_from_id
    mock_http do
      log = Gameday::EventLog.new
      log.load_from_id(GAME_ID)
      assert log.gid
      assert_equal GAME_ID, log.gid
      assert log.away_team
      assert log.home_team
      assert_equal 'Detroit', log.away_team
      assert_equal 'Minnesota', log.home_team
      assert log.away_events
      assert log.home_events
      assert log.max_inning
      assert_equal 51, log.away_events.length
      assert_equal 45, log.home_events.length
      assert_equal '12', log.away_events[0].number
      assert_equal '1', log.away_events[0].inning
      assert_equal 'Curtis Granderson strikes out swinging.  ', log.away_events[0].description
      assert_equal 'away', log.away_events[0].team
      assert_equal '42', log.home_events[0].number
      assert_equal '1', log.home_events[0].inning
      assert_equal 'Denard Span strikes out swinging.  ', log.home_events[0].description
      assert_equal 'home', log.home_events[0].team
    end
  end


  def test_events_by_inning
    mock_http do
      log = Gameday::EventLog.new
      log.load_from_id(GAME_ID)
      events = log.events_by_inning('3')
      assert_equal 8, events.length
      assert_equal '157', events[0].number
      assert_equal '3', events[0].inning
      assert_equal 'Gerald Laird grounds out, third baseman Matt Tolbert to first baseman Michael Cuddyer.  ', events[0].description
      assert_equal 'away', events[0].team
      assert_equal '202', events[7].number
      assert_equal '3', events[7].inning
      assert_equal 'Michael Cuddyer flies out to center fielder Curtis Granderson.  ', events[7].description
      assert_equal 'home', events[7].team
    end
  end

end