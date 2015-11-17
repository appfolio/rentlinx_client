module Rentlinx
  # Client methods for Amenities
  #
  # TODO: Refactor into AttachmentClientMethods
  module LinkClientMethods
    # Posts an array of links to Rentlinx
    #
    # This uses the batch endpoint, so all links must be associated with
    # the same property. They can be on different units, so long as all units
    # are on the same property.
    #
    # @param links [Array] an array of links which all have the same propertyID
    def post_links(links)
      return if links.nil?

      raise(Rentlinx::InvalidObject, links.find { |a| !a.valid? }) unless links.all?(&:valid?)
      raise(Rentlinx::IncompatibleGroupOfObjectsForPost, 'propertyID') unless links.all? { |p| p.propertyID == links.first.propertyID }

      property_links = links.select { |l| l.class == Rentlinx::PropertyLink }
      unit_links = links - property_links

      post_property_links(property_links) unless property_links.empty?
      post_unit_links(unit_links) unless unit_links.empty?
    end

    # Unposts all links for unit or property by posting an empty
    # array to the batch update endpoint
    #
    # @param object [Rentlinx::Property, Rentlinx::Unit] the object whos
    #               links should be unposted
    def unpost_links_for(object)
      case object
      when Rentlinx::Unit
        post_links_for_unit_id(object.unitID, [])
      when Rentlinx::Property
        post_links_for_property_id(object.propertyID, [])
      else
        raise TypeError, 'Type not permitted: #{object.class}'
      end
    end

    # Gets all the links for a given property, including unit links
    #
    # @param id [String] the id of the property
    def get_links_for_property_id(id)
      data = request('GET', "properties/#{id}/links")['data']
      data.map do |link_data|
        if link_data['unitID'].nil? || link_data['unitID'] == ''
          link_data.delete('unitID')
          PropertyLink.new(symbolize_data(link_data))
        else
          UnitLink.new(symbolize_data(link_data))
        end
      end
    rescue Rentlinx::NotFound
      return []
    end

    # Gets all the links for a given unit
    #
    # @param unit [Rentlinx::Unit] the unit for which links should be fetched
    def get_links_for_unit(unit)
      links = get_links_for_property_id(unit.propertyID)
      links.select { |link| defined?(link.unitID) && link.unitID == unit.unitID }
    end

    # Unposts a specific link
    #
    # @param link [Rentlinx::UnitLink, Rentlinx::PropertyLink] the link to be unposted
    def unpost_link(link)
      case link
      when Rentlinx::UnitLink
        unpost_unit_link(link.unitID, link.url)
      when Rentlinx::PropertyLink
        unpost_property_link(link.propertyID, link.url)
      else
        raise TypeError, "Invalid type: #{link.class}"
      end
    end

    private

    def post_property_links(links)
      post_links_for_property_id(links.first.propertyID, links)
    end

    def post_links_for_property_id(id, links)
      request('PUT', "properties/#{id}/links", links.map(&:to_hash))
    end

    def post_unit_links(links)
      hash = {}
      links.each do |p|
        if hash.keys.include?(p.unitID)
          hash[p.unitID] << p
        else
          hash[p.unitID] = [p]
        end
      end

      hash.each do |unit_id, unit_links|
        post_links_for_unit_id(unit_id, unit_links)
      end
    end

    def post_links_for_unit_id(id, links)
      request('PUT', "units/#{id}/links", links.map(&:to_hash))
    end

    def unpost_property_link(id, url)
      request('DELETE', URI.encode("properties/#{id}/links/"), url: url)
    end

    def unpost_unit_link(id, url)
      request('DELETE', URI.encode("units/#{id}/links/"), url: url)
    end
  end
end
