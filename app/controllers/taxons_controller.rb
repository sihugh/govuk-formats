# frozen_string_literal: true

require 'net/http'

class TaxonsController < ApplicationController
  def index
    render 'index', locals: { topics: sorted_topics }
  end

  private

  def sorted_topics
    level_one_topics.sort_by { |t| t[:name] }
  end

  def level_one_topics
    @level_one_topics ||= homepage_content_item['links']['level_one_taxons'].map do |taxon|
      {
        name: taxon['title'],
        slug: taxon['base_path']
      }
    end
  end

  def homepage_content_item
    url = 'https://www.gov.uk/api/content'
    uri = URI(url)
    response = Net::HTTP.get(uri)
    JSON.parse(response)
  end
end
