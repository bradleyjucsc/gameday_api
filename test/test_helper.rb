$: << File.expand_path(File.dirname(__FILE__) + "/../lib/")

require 'minitest/unit'
require 'test/unit'
require 'mocha'
require 'fakeweb'
require 'vcr'

require 'gameday'

MiniTest::Unit.autorun

GAME_ID  = '2009_09_20_detmlb_minmlb_1'
CASSETTE = 'gameday'

VCR::Config.stub_with :fakeweb

VCR.config do |c|
  c.cassette_library_dir = 'test/fixtures/vcr/cassettes'
  c.stub_with :fakeweb
end

def mock_http name, record = :new_episodes
  VCR.use_cassette(name, :record => record) do
    yield
  end
end  

class Fixture
  def self.local filename
    File.read(File.dirname(__FILE__) + "/fixtures/#{filename}")
  end
end
