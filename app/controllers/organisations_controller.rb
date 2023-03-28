# frozen_string_literal: true

class OrganisationsController < ApplicationController
  def index
    render "index", locals: { results: organisations_results }
  end

  def show
    render_not_found if organisation_results.empty?

    render "show", locals: { result: organisation_result, organisation_info: organisation_info }
  end

private

  def organisation_result
    @organisation_result ||= begin
      r = organisation_results.first
      {
        href: "https://www.gov.uk#{r['link']}",
        name: r["title"],
      }
    end
  end

  def organisation_results
    raw_organisation_results["results"]
  end

  def raw_organisation_results
    @raw_organisation_results ||= Search.query(organisation_search_query(organisation_slug))
  end

  def organisation_info
    r = raw_organisation_results["results"].first
    org = r["organisations"].first
    {
      "Acronym": org["acronym"],
      "Description": r["description"],
      "Type": org["organisation_type"].humanize,
    }
  end

  def organisations_results
    r = Search.query(organisations_search_query)
    r["facets"]["organisations"]["options"].map do |option|
      {
        slug: option["value"]["slug"],
        name: option["value"]["title"],
      }
    end
  end

  def organisations_search_query
    {
      count: 0,
      facet_organisations: 150,
    }
  end

  def organisation_search_query(slug)
    {
      filter_slug: slug,
    }
  end

  def organisation_slug
    params[:slug]
  end
end
