require 'rails_helper'

RSpec.describe AwardsController, type: :controller do
  let(:user) { create(:user, :with_awards) }
  let(:awards) { user.awards }

  describe 'GET #index' do
    context 'for authenticated user' do
      before do
        login(user)
        get :index
      end

      it 'assigns all user awards to @awards' do
        expect(assigns(:awards)).to match_array(awards)
      end

      it 'renders index view' do
        expect(response).to render_template :index
      end
    end

    context 'for authenticated user' do
      before { get :index }

      it 'do not assigns all user awards to @awards' do
        expect(assigns(:awards)).to_not match_array(awards)
      end

      it 'redirects to signup page' do
        expect(response).to redirect_to new_user_session_path
      end
    end
  end
end
