module Rentlinx
  module LinkClientMethods
    def post_links(links)
      return if links.nil?

      raise Rentlinx::InvalidObject, links.find { |a| !a.valid? } unless links.all?(&:valid?)
      raise Rentlinx::InvalidObject, links unless links.all? { |p| p.propertyID == links.first.propertyID }

      property_links = links.select { |l| l.class == Rentlinx::PropertyLink }
      unit_links = links - property_links

      post_property_links(property_links) unless property_links.empty?
      post_unit_links(unit_links) unless unit_links.empty?
    end

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

    def get_links_for_unit(unit)
      links = get_links_for_property_id(unit.propertyID)
      links.select { |a| defined? a.unitID && a.unitID == unit.unitID }
    end

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
      request('PUT', "properties/#{links.first.propertyID}/links", links.map(&:to_hash))
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

      hash.each do |unitID, unit_links|
        request('PUT', "units/#{unitID}/links", unit_links.map(&:to_hash))
      end
    end

    def unpost_property_link(id, url)
      request('DELETE', URI.encode("properties/#{id}/links/"), url: url)
    end

    def unpost_unit_link(id, url)
      request('DELETE', URI.encode("units/#{id}/links/"), url: url)
    end
  end
end
