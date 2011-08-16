require 'test_helper'

class TestPlayer < Test::Unit::TestCase

  CASSETTE = 'player'

  def test_load_from_id
    player = Gameday::Player.new
    mock_http CASSETTE do
      player.load_from_id(GAME_ID, '434158')
    end
    assert_equal GAME_ID, player.gid
    assert_equal '434158', player.pid
    assert_equal 'Curtis', player.first
    assert_equal 'Granderson', player.last
    assert_equal '28', player.num
    assert_equal 'Granderson', player.boxname
    assert_equal 'R', player.rl
    assert_equal 'CF', player.position
    assert_equal 'A', player.status
    assert_equal '1', player.bat_order
    assert_equal 'CF', player.game_position
    assert_equal '.250', player.avg
    assert_equal '27', player.hr
    assert_equal '63', player.rbi
    assert_equal nil, player.wins
    assert_equal nil, player.losses
    assert_equal nil, player.era

    assert_equal 'det', player.team_abbrev
    assert_equal 'batter', player.type
    assert_equal '6-1', player.height
    assert_equal '185', player.weight
    assert_equal 'L', player.bats
    assert_equal 'R', player.throws
    assert_equal '03/16/1981', player.dob
  end


  def test_get_team
    player = Gameday::Player.new
    mock_http CASSETTE do
      player.load_from_id(GAME_ID, '434158')
    end
    team = player.get_team
    assert_not_nil team
    assert_equal 'Detroit', team.city
    assert_equal 'Tigers', team.name
  end


end