module Gameday
  class Resource
    attr_accessor :raw_attrs

    def self.new_from_hash hash
      res = self.new

      res.init_from_hash hash

      res
    end

    def self.new_from_xml element
      return unless element && element.attributes.is_a?(Hash)

      res = self.new

      res.init_from_xml element

      res
    end

    def init_from_hash hash
      self.raw_attrs = hash

      hash.each do |k,v|
        next if 'id' == k.to_s
        meth = "#{k}=".to_sym
        self.send(meth, v) if self.respond_to? meth
      end
    end

    def init_from_xml element
      init_from_hash element.attributes
    end

  end
end