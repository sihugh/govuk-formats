# frozen_string_literal: true

require "json"
require "net/http"

class Search
  BASE_SEARCH_URL = "https://www.gov.uk/api/search.json?"

  def self.query(params)
    url = BASE_SEARCH_URL + params.to_query
    uri = URI(url)
    response = Net::HTTP.get(uri)
    JSON.parse(response)
  end
end
