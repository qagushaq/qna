require 'rails_helper'

RSpec.describe QuestionsController, type: :controller do
  let(:question) { create(:question) }
  let(:user) { question.user }

  describe 'GET #index' do
    let(:questions) { create_list(:question, 3) }

    before { get :index }

    it 'populates an array of all questions' do
      expect(assigns(:questions)).to match_array(questions)
    end

    it 'renders index view' do
      expect(response).to render_template :index
    end
  end

  describe 'GET #show' do
    before { get :show, params: { id: question } }

    it 'assigns the requested question to @question' do
      expect(assigns(:question)).to eq question
    end

    it 'assigns new answer for question' do
      expect(assigns(:answer)).to be_a_new(Answer)
    end

    it 'assigns new link for answer' do
      expect(assigns(:answer).links.first).to be_a_new(Link)
    end

    it 'renders show view' do
      expect(response).to render_template :show
    end
  end

  describe 'GET #new' do
    context 'for authenticated user' do
      before { login(user) }
      before { get :new }

      it 'assigns a new Question to @question' do
        expect(assigns(:question)).to be_a_new(Question)
      end

      it 'builds a new Link to @question' do
        expect(assigns(:question).links.first).to be_a_new(Link)
      end

      it 'builds a new Award to @question' do
        expect(assigns(:question).award).to be_a_new(Award)
      end

      it 'renders new view' do
        expect(response).to render_template :new
      end
    end

    context 'for unauthenticated user' do
      before { get :new }

      it 'do not assigns a new Question to @question' do
        expect(assigns(:question)).to_not be_a_new(Question)
      end

      it 'redirects to sign up page' do
        expect(response).to redirect_to new_user_session_path
      end
    end
  end

  describe 'GET #edit' do
    context 'for authenticated user' do
      before { login(user) }
      before { get :edit, params: { id: question } }

      it 'assigns the requested question to @question' do
        expect(assigns(:question)).to eq question
      end

      it 'renders edit view' do
        expect(response).to render_template :edit
      end
    end


    context 'for unauthenticated user' do
      before { get :edit, params: { id: question } }

      it 'do not assigns the requested question to @question' do
        expect(assigns(:question)).to_not eq question
      end

      it 'redirects to sign up page' do
        expect(response).to redirect_to new_user_session_path
      end
    end
  end

  describe 'POST #create' do
    context 'with valid attributes' do
      before { login(user) }

      it 'saves a new question in the database' do
        expect { post :create, params: { question: attributes_for(:question) } }.to change(Question, :count).by(1)
      end

      it 'redirects to show view' do
        post :create, params: { question: attributes_for(:question) }
        expect(response).to redirect_to assigns(:question)
      end
    end

    context 'with invalid attributes' do
      before { login(user) }

      it 'does not save the question' do
        expect { post :create, params: { question: attributes_for(:question, :invalid) } }.to_not change(Question, :count)
      end


      it 're-renders new view' do
        post :create, params: { question: attributes_for(:question, :invalid) }
        expect(response).to render_template :new
      end
    end

    context 'for unauthenticated user' do
      it 'does not save the question' do
        expect { post :create, params: { question: attributes_for(:question) } }.to_not change(Question, :count)
      end

      it 'redirects to sign up page' do
        post :create, params: { question: attributes_for(:question) }

        expect(response).to redirect_to new_user_session_path
      end
    end
  end

  describe 'PATCH #update' do
    context 'with valid attributes' do
      before { login(user) }

      it 'assigns the requested question to @question' do
        patch :update, params: { id: question, question: attributes_for(:question) }, format: :js
        expect(assigns(:question)).to eq question
      end

      it 'changes question attributes' do
        patch :update, params: { id: question, question: { title: 'new title', body: 'new body' } }, format: :js
        question.reload

        expect(question.title).to eq 'new title'
        expect(question.body).to eq 'new body'
      end

      it 'render update view' do
        patch :update, params: { id: question, question: attributes_for(:question) }, format: :js
        expect(response).to render_template :update
      end
    end

    context 'with invalid attributes' do
      before do
        login(user)
        patch :update, params: { id: question, question: attributes_for(:question, :invalid) }, format: :js
      end

      it 'does not change question' do
        question.reload

        expect(question.title).to eq 'Question String'
        expect(question.body).to eq 'Question Text'
      end

      it 'renders update view' do
        expect(response).to render_template :update
      end
    end

    context 'for not the author of the question' do
     let(:not_author) { create(:user) }

     before { login(not_author) }
     before { patch :update, params: { id: question, question: {  title: 'title', body: 'body' } } }

     it 'does not change answer' do
       question.reload

       expect(question.title).to eq 'Question String'
       expect(question.body).to eq 'Question Text'
     end

     it 're-renders edit view' do
       expect(response).to redirect_to question
     end
   end

   context 'for unauthenticated user' do
     before { patch :update, params: { id: question, question: {  title: 'title', body: 'body' } } }

     it 'does not change question' do
       question.reload

       expect(question.title).to eq 'Question String'
       expect(question.body).to eq 'Question Text'
     end

     it 'redirects to sign up page' do
       expect(response).to redirect_to new_user_session_path
     end
   end
 end

 describe 'DELETE #destroy' do
   let!(:question) { create(:question) }

   context 'for the author of the question' do
     before { login(user) }

     it 'deletes the question' do
       expect { delete :destroy, params: { id: question } }.to change(Question, :count).by(-1)
     end

    it 'redirects to index' do
      delete :destroy, params: { id: question }
      expect(response).to redirect_to questions_path
    end
  end

  context 'for not the author of the answer' do
    let(:not_author) { create(:user) }

    before { login(not_author) }

    it "don't delete the question" do
      expect { delete :destroy, params: { id: question } }.to_not change(Question, :count)
    end

    it 'redirects to question' do
      delete :destroy, params: { id: question }
      expect(response).to redirect_to question_path(question)
    end
  end

  context 'for unauthenticated user' do
    it "don't delete the question" do
      expect { delete :destroy, params: { id: question } }.to_not change(Question, :count)
    end

    it 'redirects to sign up page' do
      delete :destroy, params: { id: question }
      expect(response).to redirect_to new_user_session_path
    end
   end
  end
end
