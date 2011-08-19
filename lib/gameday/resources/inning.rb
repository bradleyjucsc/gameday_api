
module Gameday
  # This class represents a single inning of an MLB game
  class Inning < Resource

    attr_accessor :gid, :num, :away_team, :home_team, :top_atbats, :bottom_atbats


    # loads an Inning object given a game id and an inning number
    def self.fetch_by gid, inning_num
      inning = nil

      begin
        xml_data = GamedayFetcher.fetch_inningx gid, inning_num
        xml_doc = REXML::Document.new xml_data

        if xml_doc.root
          inning = self.new_from_xml xml_doc.root

          inning.gid = gid
          inning.top_atbats = inning.top_ab_from xml_doc
          inning.bottom_atbats = inning.bottom_ab_from xml_doc
        end
      rescue => e
        puts "Could not load inning file for #{gid}, inning #{inning.to_s}\n#{e}"
      end
      inning
    end

    def top_ab_from xml_doc
      atbats=[]
      xml_doc.elements.each("inning/top/atbat") { |element|
        atbats.push AtBat.new_from_xml(element, @gid, @num)
      }
      atbats
    end


    def bottom_ab_from xml_doc
      atbats=[]
      xml_doc.elements.each("inning/bottom/atbat") { |element|
        atbats.push AtBat.new_from_xml(element, @gid, @num)
      }
      atbats
    end


  end
end