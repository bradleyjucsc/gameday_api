require 'minitest/unit'
require 'mocha'
require 'gameday'

MiniTest::Unit.autorun

class Fixture
  def self.local filename
    File.read(File.dirname(__FILE__) + "/fixtures/#{filename}")
  end
end