module Rentlinx
  module Linkable
    def post_with_links
      post
      post_links
    end

    def post_links
      Rentlinx.client.post_links(@links)
    end

    def links
      return @links if @links

      @links =
        if defined? unitID
          Rentlinx.client.get_links_for_unit(self)
        else
          Rentlinx.client.get_links_for_property_id(propertyID)
        end
    end

    def links=(link_list)
      @links = link_list.map do |link|
        link.propertyID = propertyID
        link.unitID = unitID if defined? unitID
        link
      end
    end

    def add_link(options)
      options.merge!(propertyID: propertyID)
      options.merge!(unitID: unitID) if defined? unitID
      @links ||= []
      @links << link_class.new(options)
    end
  end
end
