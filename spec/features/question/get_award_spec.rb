require 'rails_helper'

feature 'User can add award to question' do
  given(:question) { create(:question, :with_award_and_answer) }
  given(:answer) { question.answers.first }

  scenario 'Author of the best answer can get the reward', js: true do
    sign_in(question.user)
    visit question_path(question)

    click_on 'Best answer'
    expect(page).to have_content "#{answer.user.email} got the #{question.award.title}"
  end
end
