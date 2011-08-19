require 'test_helper'

class TestMedia < MiniTest::Unit::TestCase


  def test_load_from_id
    mock_http do
      media = Gameday::Media.fetch_by GAME_ID

      assert media.highlights
      assert media.mobile
      assert_equal 6, media.highlights.length
      assert_equal "Punto's RBI single", media.highlights[0].headline
      assert_equal "00:00:37", media.highlights[0].duration
      assert_equal "http://mediadownloads.mlb.com/mlbam/2009/09/20/rth_6751897_th_7.jpg", media.highlights[0].thumb_url
      assert_equal "http://mediadownloads.mlb.com/mlbam/2009/09/20/mlbtv_detmin_6751897_400K.mp4", media.highlights[0].res_400_url
      assert_equal "http://mediadownloads.mlb.com/mlbam/2009/09/20/rth_detmin_6751897_500.mp4", media.highlights[0].res_500_url
      assert_equal "http://mediadownloads.mlb.com/mlbam/2009/09/20/mlbtv_detmin_6751897_800K.mp4", media.highlights[0].res_800_url
    end
  end


end
