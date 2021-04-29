require 'rails_helper'

shared_examples_for "votable" do
  it { should have_many(:votes).dependent(:destroy) }

  let(:user1) { create(:user) }
  let(:user2) { create(:user) }

  klass_instance = (described_class.new).class.to_s.underscore.split('_')[0].singularize.to_sym


  case klass_instance
  when :question
    let!(:votable) { create(klass_instance, user: user1) }
  when :answer
    let(:question) { create(:question, user: user2) }
    let!(:votable) { create(klass_instance, user: user1, question: question) }
  end

  it "rating" do
    expect(votable.rating).to eq 0
  end
end