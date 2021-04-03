require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:user) { create(:user) }
  let(:question) { create(:question, user: user) }
  let(:answer) { create(:answer, question: question, user: user) }

  describe 'Authenticated user' do
    before { login(user) }

    describe 'GET #edit' do
      before { get :edit, params: { id: answer } }

      it 'renders edit view' do
        expect(response).to render_template :edit
      end
    end
    
    describe 'POST #create' do
      context 'with valid attributes' do
        it 'saves a new answer in the database' do
          expect { post :create, params: { question_id: question, answer: attributes_for(:answer) } }.to change(question.answers, :count).by(1)
        end

        it 'redirects to show view' do
          post :create, params: { question_id: question, answer: attributes_for(:answer) }
          expect(response).to redirect_to question_path(question)
        end
      end

      context 'with invalid attributes' do
        it 'does not save the answer' do
          expect { post :create, params: { question_id: question, answer: attributes_for(:answer, :invalid) } }.to_not change(Answer, :count)
        end

        it 're-renders new view' do
          post :create, params: { question_id: question, answer: attributes_for(:answer, :invalid) }
          expect(response).to render_template "questions/show"
        end
      end
    end

    describe 'DELETE #destroy' do
      context 'If user author answer' do
        let!(:answer) { create(:answer, question: question, user: user) }

        it 'deletes the answer' do
          expect { delete :destroy, params: { id: answer } }.to change(Answer, :count).by(-1)
        end

        it 'redirects to question path' do
          delete :destroy, params: { id: answer }
          expect(response).to redirect_to question_path(question)
        end
      end

      context 'If user not author question' do
        it 'deletes the answer not author' do
          delete :destroy, params: { id: answer }
          expect(response).to redirect_to question_path(question)
        end
      end
    end
  end

  describe 'Unauthenticated user' do
    describe 'GET #edit' do
      before { get :edit, params: { id: answer } }

      it 'redirect to sign in page' do
        expect(response).to redirect_to new_user_session_path
      end
    end

    describe 'POST #create' do
      it 'redirect to sign in page' do
        post :create, params: { question_id: question, answer: attributes_for(:answer, :invalid) }
        expect(response).to redirect_to new_user_session_path
      end
    end

    describe 'DELETE #destroy' do
      it 'redirect to sign in page' do
        delete :destroy, params: { id: answer }
        expect(response).to redirect_to new_user_session_path
      end
    end
  end

end
