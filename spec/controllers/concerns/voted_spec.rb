require 'rails_helper'

shared_examples_for 'voted' do
  let(:user) { create(:user) }
  let(:author) { create(:user) }

  klass_instance = (described_class.new).class.to_s.underscore.split('_')[0].singularize.to_sym

  case klass_instance
  when :question
    let!(:votable) { create(klass_instance, user: author) }
  when :answer
    let(:question) { create(:question, user: author) }
    let!(:votable) { create(klass_instance, user: author, question: question) }
  end

  describe "PATCH #vote_up" do
    before { login(user) }

    it 'creates a vote with +1 value' do
      patch :vote_up, params: { id: votable }, format: :json
      expect(assigns(:votable)).to eq votable
    end

    it 'gets response status 200' do
      patch :vote_up, params: { id: votable }, format: :json   

      expect(response.status).to eq(200)
    end
  end

  describe "PATCH #vote_down" do
    before { login(user) }

    it 'creates a vote with -1 value' do
      patch :vote_down, params: { id: votable }, format: :json
      expect(assigns(:votable)).to eq votable      
    end

    it 'gets response status 200' do
      patch :vote_up, params: { id: votable }, format: :json   

      expect(response.status).to eq(200)
    end
  end

  describe 'DELETE #delete_vote' do

    before do
      login(user) 
      patch :vote_up, params: { id: votable }, format: :json
    end

    it 'deletes a vote'   do
      delete :delete_vote, params: { id: votable }, format: :json
      expect(assigns(:votable)).to eq votable     
    end

    it 'gets response status 200' do
      delete :delete_vote, params: { id: votable }, format: :json   

      expect(response.status).to eq(200)
    end
  end
end