require 'rails_helper'

RSpec.describe ConfirmationsController, type: :controller do
  before do
    @request.env["devise.mapping"] = Devise.mappings[:user]
  end

  describe 'POST #create' do
    context 'with valid attributes' do
      it 'saves a new user to database' do
        expect { post :create, params: { user: { email: 'user@test.com' } } }.to change(User, :count).by(1)
      end

      it 'redirects to root path' do
        post :create, params: { user: { email: 'user@test.com' } }

        expect(response).to redirect_to root_path
      end
    end

    context 'with invalid attributes' do
      it 'saves a new user to database' do
        expect { post :create, params: { user: { email: '' } } }.to_not change(User, :count)
      end

      it 'renders new template' do
        post :create, params: { user: { email: '' } }
        expect(response).to render_template 'new'
      end
    end
  end
end
