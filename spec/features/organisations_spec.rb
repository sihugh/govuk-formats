# frozen_string_literal: true

require 'rails_helper'

RSpec.feature 'Organisations', type: :feature do
  context 'index page' do
    before do
      stub_organisations_search

      visit '/organisations'
    end

    it 'renders standard page furniture' do
      expect(page).to have_title('GOV.UK Formats')
      expect(page).to have_css('h1', text: 'Organisations with most documents')
    end

    it 'shows a list of organisations' do
      expect(page).to have_link('HM Revenue & Customs', href: '/organisations/hm-revenue-customs')
    end

    def stub_organisations_search
      results = file_fixture('organisations.json').read

      stub_request(:get, 'https://www.gov.uk/api/search.json')
        .with(query: { count: 0, facet_organisations: 150 })
        .to_return(body: results)
    end
  end

  context 'show page' do
    before do
      stub_organisation_search

      visit '/organisations/ministry-of-silly-walks'
    end

    it 'renders standard page furniture' do
      expect(page).to have_title('GOV.UK Formats')
      expect(page).to have_css('h1', text: 'Ministry of silly walks')
    end

    it 'shows a list of organisations' do
      expect(page).to have_link('Ministry of silly walks', href: 'https://www.gov.uk/government/organisations/ministry-of-silly-walks')
    end

    def stub_organisation_search
      results = file_fixture('organisation.json').read

      stub_request(:get, 'https://www.gov.uk/api/search.json')
        .with(query: { filter_slug: 'ministry-of-silly-walks' })
        .to_return(body: results)
    end
  end
end
