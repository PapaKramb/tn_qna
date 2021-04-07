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
          expect { post :create, params: { question_id: question, answer: attributes_for(:answer) }, format: :js }.to change(question.answers, :count).by(1)
        end

        it 'renders create template' do
          post :create, params: { question_id: question, answer: attributes_for(:answer), format: :js }
          expect(response).to render_template :create
        end
      end

      context 'with invalid attributes' do
        it 'does not save the answer' do
          expect { post :create, params: { question_id: question, answer: attributes_for(:answer, :invalid) }, format: :js }.to_not change(Answer, :count)
        end

        it 're-renders create template' do
          post :create, params: { question_id: question, answer: attributes_for(:answer, :invalid), format: :js }
          expect(response).to render_template :create
        end
      end
    end

    describe 'PATCH #update' do
      context 'with valid attributes' do 
        it 'changes answer attributes' do
          patch :update, params: { id: answer, answer: { body: 'new body' } }, format: :js
          answer.reload
          expect(answer.body).to eq 'new body'
        end

        it 'renders update view' do
          patch :update, params: { id: answer, answer: { body: 'new body' } }, format: :js
          expect(response).to render_template :update
        end
      end

      context 'with invalid attributes' do
        it 'does not change answer attributes' do
          expect do
            patch :update, params: { id: answer, answer: attributes_for(:answer, :invalid) }, format: :js
          end.to_not change(answer, :body)  
        end

        it 'renders update view' do
          patch :update, params: { id: answer, answer: attributes_for(:answer, :invalid) }, format: :js
          expect(response).to render_template :update
        end
      end
    end

    describe 'PATCH #make_best' do
      context 'If user author question' do 
        let!(:answer) { create(:answer, question: question, user: user) }

        it 'choose answer as best' do
          patch :best_answer, params: { id: answer }, format: :js
          answer.reload
          expect(answer.best).to eq true
        end

        it 'renders to make_best view' do
          patch :best_answer, params: { id: answer }, format: :js
          expect(response).to render_template :best_answer
        end
      end

      context 'If user not author question' do 
        it 're-renders to make_best view' do
          patch :best_answer, params: { id: answer }, format: :js
          expect(response).to render_template :best_answer
        end  
      end
    end

    describe 'DELETE #destroy' do
      context 'If user author answer' do
        let!(:answer) { create(:answer, question: question, user: user) }

        it 'deletes the answer' do
          expect { delete :destroy, params: { id: answer }, format: :js }.to change(Answer, :count).by(-1)
        end

        it 'redirects to question path' do
          delete :destroy, params: { id: answer }, format: :js
          expect(response).to render_template :destroy
        end
      end

      context 'If user not author question' do
        it 'deletes the answer not author' do
          delete :destroy, params: { id: answer }, format: :js
          expect(response).to render_template :destroy
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
