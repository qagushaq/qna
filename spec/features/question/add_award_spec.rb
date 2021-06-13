require 'rails_helper'

feature 'User can add award to question' do
  given(:user) { create(:user) }
  given(:question) { create(:question, :with_award_and_answer) }
  given(:answer) { question.answers.first }

  describe 'User when asks question' do
    background do
      sign_in(user)
      visit new_question_path

      fill_in 'Title', with: 'Test question'
      fill_in 'Body', with: 'text text text'
      attach_file 'Award image', "#{Rails.root}/spec/fixtures/award.jpg"
    end

    scenario 'adds award' do
      fill_in 'Award title', with: 'Award title'

      click_on 'Ask'

      expect(page).to have_content 'The author of the best answer will get Award title award'
    end
  end

  scenario 'Author of the best answer can get the reward', js: true do
    sign_in(question.user)
    visit question_path(question)

    click_on 'Best answer'
    expect(page).to have_content "#{answer.user.email} got the #{question.award.title}"
  end
end
