require 'rails_helper'

feature 'User can create comments' do

  given! (:user) { create(:user) }
  given! (:question) { create(:question) }
  given! (:answer) { create(:answer, question: question) }

  describe 'Authenticated user' do
    background do
      sign_in(user)
      visit question_path(question)
    end

    scenario 'comments a question', js: true do
      within ".comments-question-#{question.id}" do
        fill_in 'Comment', with: 'Comment text'
        click_on 'Comment'

        expect(page).to have_content "Comment text. #{user.email}"
      end
    end

    scenario 'comments an answer', js: true do
      within ".comments-answer-#{answer.id}" do
        fill_in 'Comment', with: 'Comment text'
        click_on 'Comment'

        expect(page).to have_content "Comment text. #{user.email}"
      end
    end

    scenario 'comments a question with errors', js: true do
      within ".comments-question-#{question.id}" do
        click_on 'Comment'

        expect(page).to have_content "Body can't be blank"
      end
    end

    scenario 'comments an answer with errors', js: true do
      within ".comments-answer-#{answer.id}" do
        click_on 'Comment'

        expect(page).to have_content "Body can't be blank"
      end
    end
  end

  scenario "comment appears on another user's page", js: true do
    Capybara.using_session('user') do
      sign_in(user)
      visit question_path(question)
    end

    Capybara.using_session('quest') do
      visit question_path(question)

      expect(page).to_not have_content 'Question comment'
      expect(page).to_not have_content 'Answer comment'
    end

    Capybara.using_session('user') do
      within ".comments-question-#{question.id}" do
        fill_in 'Comment', with: 'Question comment'
        click_on 'Comment'

        expect(page).to have_content "Question comment. #{user.email}"
      end

      within ".comments-answer-#{answer.id}" do
        fill_in 'Comment', with: 'Answer comment'
        click_on 'Comment'

        expect(page).to have_content "Answer comment. #{user.email}"
      end
    end

    Capybara.using_session('quest') do
      within ".comments-question-#{question.id}" do
        expect(page).to have_content "Question comment. #{user.email}"
      end

      within ".comments-answer-#{answer.id}" do
        expect(page).to have_content "Answer comment. #{user.email}"
      end
    end
  end

  scenario 'Unauthenticated user tryes to comment a question' do
    visit question_path(question)
    expect(page).to_not have_button 'Comment'
  end
end
