require 'rails_helper'

feature 'User can sign out' do
let(:user) { create(:user) }

scenario 'Authenticated user tryes to sign out' do
  sign_in(user)
  click_on 'Log out'

  expect(page).to have_content 'Signed out successfully.'
end

scenario 'Unauthenticated user tryes to sign out' do
  visit questions_path

  expect(page).to_not have_link 'Log out'
end
end
