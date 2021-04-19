require 'rails_helper'

RSpec.describe LinksController, type: :controller do
  describe 'DELETE #destroy question' do
    let(:author) { create(:user) }
    let(:user) { create(:user) }
    let(:question) { create(:question, user: author) }

    before do
      question.links.create( linkable: question, name: "google", url: "https://www.google.com/")
    end

    context 'User is an author of resource' do
      it "deletes resource's link" do
        login(author)
        
        expect do
          delete :destroy, params: { id: question.links.first.id }, format: :js
        end.to change(question.links, :count).by(-1)      
      end
    end

    context 'User is not an author of resource' do
      it "does not deletes resource's link" do
        login(user)
        
        expect do
          delete :destroy, params: { id: question.links.first.id }, format: :js
        end.to_not change(question.links, :count)
      end
    end

    context 'Unauthenticated user' do
      it "does not deletes resource's link" do
        expect do
          delete :destroy, params: { id: question.links.first.id }, format: :js
        end.to_not change(question.links, :count)
      end
    end
  end

  describe 'DELETE #destroy answer' do
    let(:author) { create(:user) }
    let(:user) { create(:user) }
    let(:question) { create(:question, user: author) }
    let(:answer) { create(:answer, question: question, user: author) }

    before do
      answer.links.create( linkable: answer, name: "github", url: "https://www.github.com/")
    end

    context 'User is an author of resource' do
      it "deletes resource's link" do
        login(author)
        
        expect do
          delete :destroy, params: { id: answer.links.first.id }, format: :js
        end.to change(answer.links, :count).by(-1)      
      end
    end

    context 'User is not an author of resource' do
      it "does not deletes resource's link" do
        login(user)
        
        expect do
          delete :destroy, params: { id: answer.links.first.id }, format: :js
        end.to_not change(answer.links, :count)
      end
    end

    context 'Unauthenticated user' do
      it "does not deletes resource's link" do
        expect do
          delete :destroy, params: { id: answer.links.first.id }, format: :js
        end.to_not change(answer.links, :count)
      end
    end
  end
end
