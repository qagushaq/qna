require 'rails_helper'

feature 'User can delete question' do
  given(:question) { create(:question) }

  describe 'Authenticated user tryes to delete question' do
    scenario 'his question' do
      sign_in(question.user)
      visit question_path(question)
      expect(page).to have_content 'Question String'
      click_on 'Delete question'
      expect(page).to have_content 'Question succesfully deleted.'
      expect(page).to_not have_content 'Question String'
    end

    scenario "someone else's question" do
      user = create(:user)

      sign_in(user)
      visit question_path(question)

      expect(page).to_not have_link 'Delete question'
    end
  end

  scenario 'Unauthenticated user tryes to delete question' do
    visit question_path(question)

    expect(page).to_not have_link 'Delete question'
  end
end
