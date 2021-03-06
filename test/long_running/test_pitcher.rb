require 'test_helper'

class TestPitcher < MiniTest::Unit::TestCase


  def setup
    if !@pitcher
      @pitcher = Gameday::Pitcher.new
      @pitcher.load_from_id(GAME_ID, '434378')
      assert @pitcher.first_name == 'Justin'
      assert @pitcher.last_name == 'Verlander'
    end
  end


end