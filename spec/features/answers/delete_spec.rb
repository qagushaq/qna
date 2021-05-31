require 'rails_helper'

feature 'User can delete answer' do
  given(:question) { create(:question) }
  given(:answer) { create(:answer, question: question) }
  let!(:user) { create(:user) }

  describe 'Authenticated user tryes to delete answer', js: true do
    scenario 'his answer' do
      sign_in(answer.user)
      visit question_path(question)
      expect(page).to have_content 'Answer Text'

      click_on 'Delete answer'
      expect(page).to_not have_content 'Answer Text'
    end

    scenario "someone else's answer" do
      sign_in(user)
      visit question_path(answer.question)
      expect(page).to_not have_link 'Delete answer'
    end
  end

  scenario 'Unauthenticated user tryes to delete answer' do
    visit question_path(question)

    expect(page).to_not have_link 'Delete answer'
  end
end
