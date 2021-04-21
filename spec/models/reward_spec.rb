require 'rails_helper'

RSpec.describe Reward, type: :model do
  it { should have_one :user }
  it { should belong_to :question }

  it { should validate_presence_of :title }
  it { should validate_presence_of :image_url }

  let!(:author) {create(:user) }
  let!(:question) { create(:question, user: author) }
  let!(:answer) { create(:answer, question: question, user: author) }
  let!(:reward) { create(:reward, question: question) }

  describe '#reward_the_user' do

    it 'reward the user for the best answer' do
      answer.make_best

      expect(author.rewards.first).to eq reward
    end
  end
end
