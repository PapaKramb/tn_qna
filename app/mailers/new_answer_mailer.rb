class NewAnswerMailer < ApplicationMailer
  def notificate(new_answer)
    @question = new_answer.question
    @new_answer = new_answer
    @subscribers = @question.subscribers

    @subscribers.each do |subscriber|
      @subscriber = subscriber
      mail to: @subscriber.email
     end
  end
end
