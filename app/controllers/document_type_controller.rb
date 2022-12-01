# frozen_string_literal: true

class DocumentTypeController < ApplicationController
  def index
    render 'index', locals: { results: sorted_results }
  end

  def show
    render_not_found if results_for_doc_type.empty?

    render 'show', locals: {
      document_type: document_type.humanize.pluralize,
      results: results_for_doc_type,
      organisations: orgs_for_doc_type
    }
  end

  private

  def sorted_results
    results.sort_by { |result| result[:document_type] }
  end

  def raw_results_for_doc_type
    @raw_results_for_doc_type ||= Search.query(docs_of_type_query(document_type))
  end

  def orgs_for_doc_type
    raw_results_for_doc_type['facets']['organisations']['options'].map do |option|
      { title: option['value']['title'], slug: option['value']['slug'] }
    end
  end

  def results_for_doc_type
    raw_results_for_doc_type['results'].map do |result|
      {
        title: result['title'],
        href: "https://www.gov.uk#{result['link']}"
      }
    end
  end

  def results
    r = Search.query(all_document_types_query)
    r['facets']['content_store_document_type']['options'].map do |option|
      f = option['value']['slug']
      { document_type: f, name: f.humanize.pluralize }
    end
  end

  def all_document_types_query
    {
      count: 0,
      facet_content_store_document_type: 150
    }
  end

  def docs_of_type_query(document_type)
    {
      count: 50,
      filter_content_store_document_type: document_type,
      facet_organisations: 20,
      fields: %w[link title]
    }
  end

  def document_type
    params[:document_type].underscore
  end
end
