require 'rails_helper'

feature 'User can browse all questions' do
  let!(:questions) { create_list(:question, 2) }

  scenario 'User can visit page with all questions' do
    visit questions_path

    expect(page).to have_content('Question String', count: 2)
  end
end
