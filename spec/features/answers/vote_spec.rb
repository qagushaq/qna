require 'rails_helper'

feature 'User can vote for answer' do
  given(:user) { create(:user) }
  given!(:question) { create(:question) }
  given!(:answer) { create(:answer, question: question) }
  given(:vote) { create(:vote, votable: answer) }

  describe 'Authenticated user' do
    background do
      sign_in(user)
      visit question_path(question)

      within '.answers' do
        expect(page).to have_content 'Rating: 0'
        expect(page).to have_link 'Up'
        expect(page).to have_link 'Down'
      end
    end

    scenario 'votes for answer', js: true do
      within '.answers' do
        click_on 'Up'

        expect(page).to have_content 'Rating: 1'
        expect(page).to have_content 'You voted'
        expect(page).to_not have_link 'Up'
        expect(page).to_not have_link 'Down'
      end
    end

    scenario 'votes against answer', js: true do
      within '.answers' do
        click_on 'Down'

        expect(page).to have_content 'Rating: -1'
        expect(page).to have_content 'You voted'
        expect(page).to_not have_link 'Up'
        expect(page).to_not have_link 'Down'
      end
    end
  end

  scenario 're-votes', js: true do
    sign_in(vote.user)
    visit question_path(question)

    within '.answers' do
      expect(page).to have_content 'Rating: 1'
      expect(page).to have_content 'You voted'
      expect(page).to_not have_link 'Up'
      expect(page).to_not have_link 'Down'
      expect(page).to have_link 'Revote'

      click_on 'Revote'

      expect(page).to have_content 'Rating: 0'
      expect(page).to have_link 'Up'
      expect(page).to have_link 'Down'
    end
  end

  scenario 'Author of answer tryes to vote' do
    sign_in(answer.user)
    visit question_path(question)

    within '.answers' do
      expect(page).to_not have_link 'Up'
      expect(page).to_not have_link 'Down'
    end
  end

  scenario 'Unauthenticated user tryes to vote' do
    visit question_path(question)

    expect(page).to_not have_link 'Up'
    expect(page).to_not have_link 'Down'
  end
end
