# frozen_string_literal: true

require 'rails_helper'

RSpec.feature 'Document types', type: :feature do
  context 'index page' do
    before do
      stub_content_type_search
      visit '/document-types'
    end

    it 'renders standard page furniture' do
      expect(page).to have_title('GOV.UK Formats')
      expect(page).to have_css('h1', text: 'GOV.UK document types')
    end

    it 'shows a list of document types' do
      expect(page).to have_link('Publications', href: '/document-types/publication')
    end

    it 'knows about capitalising acronyms' do
      expect(page).to have_link('Hmrc manual sections', href: '/document-types/hmrc-manual-section')
    end

    def stub_content_type_search
      results = file_fixture('facet_formats.json').read

      stub_request(:get, 'https://www.gov.uk/api/search.json')
        .with(query: { count: 0, facet_content_store_document_type: 150 })
        .to_return(body: results)
    end
  end

  context 'show pages' do
    before do
      stub_content_type_search
      visit '/document-types/answer'
    end

    it 'renders standard page furniture' do
      expect(page).to have_title('GOV.UK Formats')
      expect(page).to have_css('h1', text: 'Most visited Answers')
    end

    it 'shows a list of example documents' do
      expect(page).to have_link('How big is a horse', href: 'https://www.gov.uk/how-big-is-a-horse')
      expect(page).to have_link('Is NASA real', href: 'https://www.gov.uk/is-nasa-real')
    end

    def stub_content_type_search
      results = file_fixture('document_types_answers.json').read

      stub_request(:get, 'https://www.gov.uk/api/search.json')
        .with(
          query: {
            count: 50,
            facet_organisations: 20,
            filter_content_store_document_type: 'answer',
            fields: %w[link title]
          }
        )
        .to_return(body: results)
    end
  end
end
