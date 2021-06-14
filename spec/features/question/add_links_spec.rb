require 'rails_helper'

feature 'User can add links to question', %q{
  In order to provide additional info to my question
  As an question's author
  I'd like to be able to add links
} do

  given(:user) { create(:user) }
  given(:gist_url) { 'https://gist.github.com/qagushaq/9e8dfcadab09e7bb941bbf6ac0ea1b4d' }
  given(:mail_url) { 'https://mail.ru' }
  given!(:question) { create(:question) }

  scenario 'User adds links when asks question', js: true do
    sign_in(user)
    visit new_question_path

    fill_in 'Title', with: 'Test question'
    fill_in 'Body', with: 'text text text'

    fill_in 'Link name', with: 'My gist'
    fill_in 'Url', with: gist_url

    click_on 'Add link'

    within all('.nested-fields').last do
      fill_in 'Link name', with: 'Mail'
      fill_in 'Url', with: mail_url
    end

    click_on 'Ask'

    expect(page).to have_link 'My gist', href: gist_url
    expect(page).to have_link 'Mail', href: mail_url
  end

  scenario 'User adds links when edits his question', js: true do
    sign_in(question.user)
    visit question_path(question)

    click_on 'Edit question'

    within '.question' do
      click_on 'Add link'

      fill_in 'Link name', with: 'My gist'
      fill_in 'Url', with: gist_url

      click_on 'Add link'

      within all('.nested_fields').last do
        fill_in 'Link name', with: 'Mail'
        fill_in 'Url', with: mail_url
      end

      click_on 'Save'

      expect(page).to have_link 'My gist', href: gist_url
      expect(page).to have_link 'Mail', href: mail_url
    end
  end

end
