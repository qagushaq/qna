require 'rails_helper'

RSpec.describe FilesController, type: :controller do
  describe 'DELETE #destroy' do
    let!(:user) { create(:user) }
    let!(:file) { fixture_file_upload("#{Rails.root}/spec/rails_helper.rb", 'text/plain') }
    let!(:resource) { create(:question, user: user, files: [file]) }
    let!(:others_resource) { create(:question, user: create(:user), files: [file]) }

    context 'Authenticated user' do
      before { login(user) }

      context 'Is author' do

        it 'can remove files' do
          expect { delete :destroy, params: { id: resource.files.first }, format: :js}.to change(resource.files, :count).by(-1)
        end

        it 'render destroy template' do
          delete :destroy, params: { id: resource.files.first }, format: :js
          expect(response).to render_template :destroy
        end
      end

      it 'NOT author trying to delete files' do
        expect { delete :destroy, params: { id: others_resource.files.first }, format: :js}.to_not change(others_resource.files, :count)
      end
    end


    it 'Unauthenticated user cant remove files' do
      expect { delete :destroy, params: { id: resource.files.first }, format: :js}.to_not change(resource.files, :count)
    end
  end
end
