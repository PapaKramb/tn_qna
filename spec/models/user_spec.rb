require 'rails_helper'

RSpec.describe User, type: :model do
  let(:author) { create(:user) }
  let(:user) { create(:user) }
  let(:question) { create(:question, user: author) }

  it { should have_many(:rewards) }
  it { should have_many(:questions).dependent(:destroy) }
  it { should have_many(:answers).dependent(:destroy) }
  it { should have_many(:votes).dependent(:destroy) }

  it { should validate_presence_of :email }
  it { should validate_presence_of :password }

  describe '#author' do
    it 'user is author' do
      expect(author).to be_author(question)
    end
  
    it 'user is not author' do
      expect(user).not_to be_author(question)
    end
  end  
end
