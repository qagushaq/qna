require 'rails_helper'

feature 'User can delete links from his answer' do
  given(:answer) { create(:answer, :with_link) }

  scenario 'User deletes links when edits his answer', js: true do
    sign_in(answer.user)
    visit question_path(answer.question)

    expect(page).to have_link 'Mail', href: 'https://mail.ru/'

    within '.answers' do
      click_on 'Edit'
      click_on 'Delete link'
      click_on 'Save'
    end

    expect(page).to_not have_link 'Mail', href: 'https://mail.ru/'
  end
end
