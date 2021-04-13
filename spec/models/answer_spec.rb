require 'rails_helper'

RSpec.describe Answer, type: :model do
  it { should belong_to(:user) }
  it { should belong_to(:question) }

  it { should validate_presence_of :body }

  describe '#make_best' do
    let(:user) { create(:user) }
    let!(:question) { create(:question, user: user) }
    let!(:first_answer) { create(:answer, question: question, user: user) }
    let!(:second_answer) { create(:answer, question: question, user: user) }
    
    it 'choose as the best answer' do
      first_answer.make_best
      
      expect(first_answer).to be_best
    end

    it 'the best answer can only be 1' do
      first_answer.make_best
      second_answer.make_best
      
      expect(question.answers.where(best: :true).count).to eq 1
    end 
  end

  it 'have many attached files' do
    expect(Answer.new.files).to be_an_instance_of(ActiveStorage::Attached::Many)
  end
end
