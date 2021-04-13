require 'rails_helper'

RSpec.describe FilesController, type: :controller do
  describe 'DELETE #destroy' do
    let!(:user) { create(:user) }
    let!(:file) { fixture_file_upload("#{Rails.root}/spec/rails_helper.rb", 'text/plain') }
    let!(:resource) { create(:question, user: user, files: [file]) }
    let!(:others_resource) { create(:question, user: create(:user), files: [file]) }

    context 'authenticated user' do
      before { login(user) }

      context 'author' do
        it 'can remove files' do
          expect do
            delete :destroy, params: { id: resource.files.first }, format: :js
          end.to change(resource.files, :count).by(-1)
        end

        it 'render destroy' do
          delete :destroy, params: { id: resource.files.first }, format: :js
          expect(response).to render_template :destroy
        end
      end

      it 'not author trying to delete files' do
        expect do
          delete :destroy, params: { id: others_resource.files.first }, format: :js
        end.to_not change(others_resource.files, :count)
      end
    end

    it 'unauthenticated user cant remove files' do
      expect do
        delete :destroy, params: { id: resource.files.first }, format: :js
      end.to_not change(resource.files, :count)
    end
  end
end
