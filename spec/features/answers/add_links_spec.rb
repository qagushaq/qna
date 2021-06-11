require 'rails_helper'

feature 'User can add links to answer', %q{
  In order to provide additional info to my answer
  As an question's author
  I'd like to be able to add links
} do

  given(:user) {create(:user)}
  given!(:question) {create(:question)}
  given(:gist_url) { 'https://gist.github.com/qagushaq/9e8dfcadab09e7bb941bbf6ac0ea1b4d' }
  given(:mail_url) { 'https://mail.ru' }
  given(:answer) { create(:answer) }


  scenario 'User adds links when give an answer', js: true do
    sign_in(user)

    visit question_path(question)

    fill_in 'Your answer', with: 'My answer'

    fill_in 'Link name', with: 'My gist'
    fill_in 'Url', with: gist_url

    click_on 'Add link'

    within all('.nested-fields').last do
      fill_in 'Link name', with: 'Mail'
      fill_in 'Url', with: mail_url
    end

    click_on 'Answer'

    within '.answers' do
      expect(page).to have_link 'My gist', href: gist_url
      expect(page).to have_link 'Mail', href: mail_url
    end
  end

  scenario 'User adds links when edits his answer', js: true do
    sign_in(answer.user)
    visit question_path(answer.question)

    click_on 'Edit'

    within '.answer' do
      click_on 'Add link'

      fill_in 'Link name', with: 'My gist'
      fill_in 'Url', with: gist_url

      click_on 'Add link'

      within all('.nested-fields').last do
        fill_in 'Link name', with: 'Mail'
        fill_in 'Url', with: mail_url
      end

      click_on 'Save'

      expect(page).to have_link 'My gist', href: gist_url
      expect(page).to have_link 'Mail', href: mail_url
    end
  end

end
