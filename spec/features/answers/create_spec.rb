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

    scenario 'Answers the question with attached file', js: true do
      fill_in 'Your answer', with: 'Answer text'
      attach_file 'File', ["#{Rails.root}/spec/rails_helper.rb", "#{Rails.root}/spec/spec_helper.rb"]

      click_on 'Answer'

      expect(page).to have_link 'rails_helper.rb'
      expect(page).to have_link 'spec_helper.rb'
    end

    scenario 'Authenticated user creates answer with errors', js: true do
      click_on 'Answer'

      expect(page).to have_content "Body can't be blank"
    end
  end


  scenario "answer appears on another user's page", js: true do
    Capybara.using_session('user') do
      sign_in(user)
      visit question_path(question)
    end

    Capybara.using_session('quest') do
      visit question_path(question)

      expect(page).to_not have_content 'Answer text'
      expect(page).to_not have_link 'spec_helper.rb'
      expect(page).to_not have_link 'Google'
    end

    Capybara.using_session('user') do
      fill_in 'Body', with: 'Answer text'
      attach_file 'File', ["#{Rails.root}/spec/spec_helper.rb"]
      fill_in 'Link name', with: 'Google'
      fill_in 'Url', with: 'https://google.com'

      click_on 'Answer'

      expect(page).to have_content 'Question String'
      expect(page).to have_content 'Question Text'
      expect(page).to have_content 'Answer text'
      expect(page).to have_link 'spec_helper.rb'
      expect(page).to have_link 'Google', href: 'https://google.com'
    end

    Capybara.using_session('quest') do
      expect(page).to have_content 'Question String'
      expect(page).to have_content 'Question Text'
      expect(page).to have_content 'Answer text'
      expect(page).to have_link 'spec_helper.rb'
      expect(page).to have_link 'Google', href: 'https://google.com'
    end
  end

  scenario 'Unauthenticated user tryes to answers the question' do
    visit question_path(question)
    expect(page).to_not have_link 'Answer'
  end

end
