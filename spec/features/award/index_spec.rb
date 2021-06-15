require 'rails_helper'

feature 'User can browse all his awards' do
  let!(:current_user) { create(:user, :with_awards)}
  let!(:user) { create(:user, :with_awards)}
  let(:question1) { current_user.awards[0].question }
  let(:question2) { current_user.awards[1].question }
  let(:question3) { user.awards[0].question }
  let(:question4) { user.awards[1].question }
  let(:question5) { create(:question, :with_award) }
  let(:image_name1) { question1.award.image.filename.to_s }
  let(:image_name2) { question2.award.image.filename.to_s }

  scenario 'User visit page with all his awards' do
    sign_in(current_user)
    visit awards_path

    within "#award-#{question1.award.id}" do
      expect(page).to have_content question1.title
      expect(page).to have_content question1.award.title
      expect(page.find('#award-image')['src']).to have_content image_name1
    end

    within "#award-#{question2.award.id}" do
      expect(page).to have_content question2.title
      expect(page).to have_content question2.award.title
      expect(page.find('#award-image')['src']).to have_content image_name2
    end

    expect(page).not_to have_css("#award-#{question3.award.id}")
    expect(page).not_to have_css("#award-#{question4.award.id}")
    expect(page).not_to have_css("#award-#{question5.award.id}")
  end
end
