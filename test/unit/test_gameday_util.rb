require 'test_helper'

class TestGamedayUtil < MiniTest::Unit::TestCase
  
  
  def test_parse_date_string
    date = '20100401'
    result = Gameday::Helpers.parse_date_string(date)
    assert result
    assert_equal '2010', result[0]
    assert_equal '04', result[1]
    assert_equal '01' , result[2]
  end
  
  
  def test_convert_digit_to_string
    result = Gameday::Helpers.convert_digit_to_string(8)
    assert_equal '08', result
    
    result = Gameday::Helpers.convert_digit_to_string(0)
    assert_equal '00', result
    
    result = Gameday::Helpers.convert_digit_to_string(12)
    assert_equal '12', result
  end
  
  
  def test_parse_gameday_id
    gid = 'gid_2008_04_07_atlmlb_colmlb_1'
    gd_info = Gameday::Helpers.parse_gameday_id(gid)
    assert gd_info
    assert_equal '2008', gd_info["year"]
    assert_equal '04', gd_info["month"]
    assert_equal '07', gd_info["day"]
    assert_equal 'atl', gd_info['visiting_team_abbrev']
    assert_equal 'col', gd_info['home_team_abbrev']
    assert_equal '1', gd_info['game_number']
  end
  
  
  def test_read_config
    Gameday::GamedayUtil.read_config
  end
  
  
  def test_get_connection
    url = 'http://www.google.com'
    Gameday::GamedayUtil.expects(:open).with(url).returns('Hello')
    con = Gameday::GamedayUtil.get_connection(url)
    assert_equal 'Hello', con
  end
  
  
  def test_net_http
    result = Gameday::GamedayUtil.net_http
    assert result
  end
  
  
  def test_is_date_valid
    assert !Gameday::Helpers.is_date_valid(4, 31)
    assert !Gameday::Helpers.is_date_valid(6, 31)
    assert !Gameday::Helpers.is_date_valid(9, 31)
    assert !Gameday::Helpers.is_date_valid(04, 1)
    assert !Gameday::Helpers.is_date_valid(04, 4)
    assert Gameday::Helpers.is_date_valid(04, 5)
  end
  
  
end
