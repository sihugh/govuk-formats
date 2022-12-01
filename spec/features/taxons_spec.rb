# frozen_string_literal: true

require 'rails_helper'

RSpec.feature 'Taxons', type: :feature do
  context 'index page' do
    before do
      stub_taxons_request

      visit '/taxons'
    end

    it 'renders standard page furniture' do
      expect(page).to have_title('GOV.UK Formats')
      expect(page).to have_css('h1', text: 'Top level taxonomy pages')
    end

    it 'shows a list of organisations' do
      expect(page).to have_link('Going and being abroad')
    end

    def stub_taxons_request
      results = file_fixture('homepage.json').read

      stub_request(:get, 'https://www.gov.uk/api/content')
        .to_return(body: results)
    end
  end
end
