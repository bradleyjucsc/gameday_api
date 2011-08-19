module Gameday
  class Hitchart < Resource

    attr_accessor :hips, :gid

    def self.fetch_by gid
      h = self.new
      h.gid = gid

      xml_data = GamedayFetcher.fetch_inning_hit gid
      xml_doc = REXML::Document.new xml_data
      if xml_doc.root
        h.hips = []
        xml_doc.elements.each("hitchart/hip") do |element|
          h.hips << Hip.new_from_xml(element)
        end
      end

      h
    end


  end
end
