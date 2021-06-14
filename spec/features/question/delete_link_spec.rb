require 'rails_helper'

feature 'User can delete links from his question' do
  given(:question) { create(:question, :with_link) }

  scenario 'User deletes links when edits question', js: true do
    sign_in(question.user)
    visit question_path(question)

    expect(page).to have_link 'Mail', href: 'https://mail.ru/'

    within '.question' do
      click_on 'Edit question'
      click_on 'Delete link'
      click_on 'Save'
    end

    expect(page).to_not have_link 'Mail', href: 'https://mail.ru/'
  end
end
