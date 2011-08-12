require 'open-uri'
require 'yaml'

module Gameday
  # This class provides a variety of utility methods that are used in other classes
  class GamedayUtil

    @@fetcher = ''


    # Returns an instance of the configured fetcher, either remote or local
    def self.fetcher
      if @@fetcher == ''
        read_config
      end
      if @@fetcher == 'local'
        return GamedayLocalFetcher
      else
        return GamedayRemoteFetcher
      end
    end


    def self.set_fetcher(fetcher)
      @@fetcher = fetcher
    end


    # Create instance configuration variables
    # try to read configuration from, in order:
    # 1) ./config/gameday.yml
    # 2) ./config/gameday_config.yml
    # 3) gameday_config.yml in this file's parent directory (lib/)
    def self.read_config
      filename = './config/gameday.yml'
      filename = './config/gameday_config.yml' unless File.exist? filename
      filename = File.expand_path(File.dirname(__FILE__) + "/../gameday_config.yml") unless File.exist? filename

      settings = YAML::load_file filename
      set_proxy_info(settings)
      set_data_fetcher(settings)
    end


    def self.get_connection(url)
      self.read_config
      begin
        if !@@proxy_addr.empty?
          connection = open(url, :proxy => "http://#{@@proxy_addr}:#{@@proxy_port}")
        else
          connection = open(url)
        end
        connection
      rescue
        puts 'Could not open connection'
      end
    end


    def self.net_http
      self.read_config
      if !@@proxy_addr.empty?
        return Net::HTTP::Proxy(@@proxy_addr, @@proxy_port)
      else
        return Net::HTTP
      end
    end


    private

    def self.set_proxy_info(settings)
      @@proxy_addr, @@proxy_port = '', ''
      if settings['proxy']
        @@proxy_addr = settings['proxy']['host']
        @@proxy_port = settings['proxy']['port']
      end
    end


    # Sets either remote or local data fetcher for retrieving XML data
    def self.set_data_fetcher(settings)
      @@fetcher = settings['fetcher']
    end


  end
end