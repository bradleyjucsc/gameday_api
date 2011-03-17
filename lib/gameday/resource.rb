module Gameday
  class Resource

    def self.new_from_hash hash
      res = self.new
      hash.each do |k,v|
        meth = "#{k}=".to_sym
        res.send(meth, v) if res.respond_to? meth
      end
    end

    def self.new_from_xml element
      return unless element.try(:attributes) === Hash

      new_from_hash element.attributes
    end
  end
end