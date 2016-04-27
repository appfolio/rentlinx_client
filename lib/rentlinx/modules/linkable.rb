module Rentlinx
  # A module that encapsulates all link related logic for {Rentlinx::Property} and
  # {Rentlinx::Unit} objects. All of these methods can be called on Properties and Units.
  #
  # TODO: Refactor into BaseAble class along with {Amenityable} and {Photoable}
  module Linkable
    # Posts the object with associated links
    #
    # TODO: Discuss whether or not these kinds of methods are needed,
    # or whether we should have post do everything every time.
    def post_with_links
      post
      post_links
    end

    # Posts the links for an object
    def post_links
      return if @links.nil?

      if @links.empty?
        Rentlinx.client.unpost_links_for(self)
      else
        Rentlinx.client.post_links(@links)
      end
    end

    # Loads and caches the list of amenities from Rentlinx.
    #
    # @return a list of amenities
    def links
      @links ||=
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
      options[:propertyID] = propertyID
      options[:unitID] = unitID if defined? unitID
      @links ||= []
      @links << link_class.new(options)
    end
  end
end
