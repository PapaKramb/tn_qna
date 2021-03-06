require 'rails_helper'

RSpec.describe Ability, type: :model do
  subject(:ability) { Ability.new(user) }

  describe 'for guest' do
    let(:user) { nil }

    it { should be_able_to :read, Question }
    it { should be_able_to :read, Answer }
    it { should be_able_to :read, Comment }

    it { should_not be_able_to :manage, :all }
  end

  describe 'for admin' do
    let(:user) { create :user, admin: true }

    it { should be_able_to :manage, :all }
  end

  describe 'for user' do
    let(:user) { create :user }
    let(:other) { create :user }
    let(:question) { create(:question, user: user) }
    let(:other_question) { create(:question, user: other) }

    it { should_not be_able_to :manage, :all }
    it { should be_able_to :read, :all }

    it { should be_able_to :create, Question }
    it { should be_able_to :create, Answer }
    it { should be_able_to :create, Comment }

    it { should be_able_to :update, create(:question, user: user) }
    it { should_not be_able_to :update, create(:question, user: other) }

    it { should be_able_to :destroy, create(:question, user: user) }
    it { should_not be_able_to :destroy, create(:question, user: other) }

    it { should be_able_to :update, create(:answer, question: question, user: user) }
    it { should_not be_able_to :update, create(:answer, question: question, user: other) }

    it { should be_able_to :destroy, create(:answer, question: question, user: user) }
    it { should_not be_able_to :destroy, create(:answer, question: question, user: other) }

    it { should be_able_to :best_answer, create(:answer, question: question, user: user) }

    it { should be_able_to :destroy, create(:link, linkable: create(:question, user: user)) }
    it { should_not be_able_to :destroy, create(:link, linkable: create(:question, user: other)) }

    it { should be_able_to %i[vote_up vote_down], other_question }
    it { should_not be_able_to %i[vote_up vote_down], question }
    it { should_not be_able_to :delete_vote, question }

    context 'API' do
      context 'Profiles' do
        it { should be_able_to :me, user}  
      end
    end

    context 'subscribes' do
      let(:question) { create(:question, user: user) }
      let(:user_subscribe)  { create(:subscribe, question: question, subscriber: user) }
      let(:other_subscribe) { create(:subscribe, question: question, subscriber: other) }      

      context '#create' do
        it { should be_able_to :create, Subscribe }
      end

      context '#destroy' do
        it { should     be_able_to :destroy, user_subscribe }
        it { should_not be_able_to :destroy, other_subscribe }
      end
    end
  end
end