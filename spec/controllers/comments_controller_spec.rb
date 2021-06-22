require 'rails_helper'

RSpec.describe CommentsController, type: :controller do
  let(:question) { create(:question) }
  let(:user) { create(:user) }

  describe 'POST #create' do
    context 'with valid attributes' do
      before { login(user) }

      it 'saves a new comment in database' do
        expect { post :create, params: { comment: attributes_for(:comment),
                                         question_id: question,
                                         user: user }, format: :js }.to change(question.comments, :count).by(1)
      end

      it 'renders create view' do
        post :create, params: { comment: attributes_for(:comment),
                                question_id: question,
                                user: user }, format: :js

        expect(response).to have_http_status 200
      end
    end

    context 'with invalid attributes' do
      before { login(user) }

      it 'does not save the comment' do
        expect { post :create, params: { comment: attributes_for(:comment, :invalid),
                                         question_id: question,
                                         user: user }, format: :js }.to_not change(question.comments, :count)
      end

      it 'renders create view' do
        post :create, params: { comment: attributes_for(:comment, :invalid),
                                         question_id: question,
                                         user: user }, format: :js

        expect(response).to have_http_status 200
      end
    end

    context 'for unauthenticated user' do
      it 'does not save the question' do
        expect { post :create, params: { comment: attributes_for(:comment),
                                         question_id: question,
                                         user: user }, format: :js }.to_not change(question.comments, :count)
      end

      it 'redirects to sign up page' do
        post :create, params: { comment: attributes_for(:comment),
                                         question_id: question,
                                         user: user }, format: :js

        expect(response).to have_http_status 401
      end
    end
  end
end
