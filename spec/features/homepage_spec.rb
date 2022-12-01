# frozen_string_literal: true

require 'rails_helper'

RSpec.feature 'Homepage', type: :feature do
  before do
    visit '/'
  end

  it 'has standard page furniture' do
    expect(page).to have_title('GOV.UK Formats')
    expect(page).to have_css('h1', text: 'GOV.UK Formats on GOV.UK')
  end

  it 'shows a link to the document types page' do
    expect(page).to have_link('Document types', href: '/document-types')
  end
end
