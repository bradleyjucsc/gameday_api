module Gameday
  class Resource
    attr_accessor :raw_attrs

    def self.new_from_hash hash
      res = self.new
      res.raw_attrs = hash

      hash.each do |k,v|
        meth = "#{k}=".to_sym
        res.send(meth, v) if res.respond_to? meth
      end

      res
    end

    def self.new_from_xml element
      return unless element && element.attributes.is_a?(Hash)

      new_from_hash element.attributes
    end
  end
end