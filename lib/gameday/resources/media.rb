module Gameday
  class Media < Resource
  
    attr_accessor :gid, :highlights, :mobile
  
    def self.fetch_by gid
      media = self.new
      media.gid = gid
      media.highlights = fetch_highlights_by gid
      media.mobile = fetch_mobile_by gid

      media
    end

    def self.fetch_highlights_by gid
      highlights = []
      xml_highlights = GamedayFetcher.fetch_media_highlights(gid)
      xml_doc = REXML::Document.new(xml_highlights)
      if xml_doc.root
        xml_doc.elements.each("highlights/media") do |element| 
          highlights << MediaHighlight.new(element)
        end
      end

      highlights
    end

    def self.fetch_mobile_by gid
      mobile = []
      xml_mobile = GamedayFetcher.fetch_media_mobile(gid)
      xml_doc = REXML::Document.new(xml_mobile)
      if xml_doc.root
        xml_doc.elements.each("mobile/media") do |element| 
          mobile << MediaMobile.new(element)
        end
      end

      mobile
    end

  end
end
