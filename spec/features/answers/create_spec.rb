require 'rails_helper'

feature 'User can give an answer', %q{
  In order to share my knowledge
  As an authenticated user
  I want to be able to create answers
} do

  given(:user) { create(:user) }
  given!(:question) { create(:question) }

  describe 'Authenticated user' do
  background do
    sign_in(user)
    visit question_path(question)
  end

    scenario 'Authenticated user create answer', js: true do
      fill_in 'Your answer', with: 'Answer text'
      click_on 'Answer'

      expect(current_path).to eq question_path(question)
      within '.answers' do # чтобы убедиться, что ответ в списке, а не в форме
       expect(page).to have_content 'Answer text'
      end
    end

    scenario 'Authenticated user creates answer with errors', js: true do
      click_on 'Answer'

      expect(page).to have_content "Body can't be blank"
    end
  end

  scenario 'Unauthenticated user tryes to answers the question' do
    visit question_path(question)
    expect(page).to_not have_link 'Answer'
  end

end
