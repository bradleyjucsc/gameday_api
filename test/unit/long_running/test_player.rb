$: << File.expand_path(File.dirname(__FILE__) + "/../../../lib")

require 'test/unit'
require 'player'

class TestPlayer < MiniTest::Unit::TestCase
  

  def setup
    if !@player
      @player = Gameday::Player.new
      @player.load_from_id(GAME_ID, '434158')
    end
  end
  
  
  def test_long_running
    get_all_appearances_test
  end
  
  
  def get_all_appearances_test
    appearances = @player.get_all_appearances('2009')
    assert appearances
    assert appearances.length == 160
  end


end