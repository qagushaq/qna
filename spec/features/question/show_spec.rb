require 'rails_helper'

feature 'User can browse question with answers' do
  let!(:question) { create(:question) }
  let!(:answers) { create_list(:answer, 2, question: question) }

  scenario 'User can visit page with all questions', js: true do
    visit question_path(question)

    expect(page).to have_content('Answer Text', count: 2)
  end
end
