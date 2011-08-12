require 'test_helper'

class TestResource < MiniTest::Unit::TestCase
  class FakeResource < Gameday::Resource
    attr_accessor :a, :b
  end

  def setup
    @hash = {
      :a => 'eh',
      :b => 'bee',
      :c => 'see'
    }
  end

  def test_new_from_hash
    r = FakeResource.new_from_hash @hash
    assert_equal @hash,     r.raw_attrs
    assert_equal @hash[:a], r.a
    assert_equal @hash[:b], r.b
  end
end
