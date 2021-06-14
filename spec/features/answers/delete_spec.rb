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


    scenario 'delete question with attached file', js: true do
      sign_in(answer.user)
      visit question_path(question)

      click_on 'Edit answer'

      within '.answers' do
        attach_file 'File', ["#{Rails.root}/spec/rails_helper.rb", "#{Rails.root}/spec/spec_helper.rb"]
        click_on 'Save'
      end

      visit question_path(question)

      expect(page).to have_link 'rails_helper.rb'
      expect(page).to have_link 'spec_helper.rb'

      within "#file_#{answer.files.first.id}" do
        click_on 'Delete file'
      end

      expect(page).to_not have_link 'rails_helper.rb'
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
