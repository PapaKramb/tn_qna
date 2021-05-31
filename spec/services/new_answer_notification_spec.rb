require 'rails_helper'

RSpec.describe NewAnswerService do 
  let(:author) { create(:user) }
  let(:question) { create(:question, user: author) }
  let!(:new_answer) { create(:answer, question: question, user: author) }

  it "sends new answer notification to question's subscribers" do

    expect(NewAnswerMailer).to receive(:notificate).with(new_answer).and_call_original 

    subject.send_notification(new_answer)
  end
end